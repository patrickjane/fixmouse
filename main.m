#import <Foundation/Foundation.h>
#import <IOKit/hidsystem/IOHIDLib.h>
#import <stdio.h>

int get()
{
   NXEventHandle handle = MACH_PORT_NULL;
   io_service_t service = MACH_PORT_NULL;
   mach_port_t masterPort;
   CFTypeRef typeRef = NULL;
   CFNumberRef number = NULL;
   unsigned int acceleration;

   kern_return_t res = IOMasterPort(MACH_PORT_NULL, &masterPort);

   if (res == KERN_SUCCESS)
      service = IORegistryEntryFromPath(masterPort, kIOServicePlane ":/IOResources/IOHIDSystem");

   if (res == KERN_SUCCESS && service)
      res = IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &handle);
   
   if (res == KERN_SUCCESS)
      res = IOHIDCopyCFTypeParameter(handle, CFSTR(kIOHIDMouseAccelerationType), &typeRef);
   
   if (res == KERN_SUCCESS)
   {
      number = (CFNumberRef)typeRef;
      CFNumberGetValue(number, kCFNumberSInt32Type, &acceleration);
      CFRelease(typeRef);
      IOObjectRelease(service);
      
      printf("Acceleration is %d\n", acceleration);
   }
   
   return 0;
}

int set()
{
   NSInteger value = -65536;
   CFNumberRef number = CFNumberCreate(kCFAllocatorDefault, kCFNumberNSIntegerType, &value);
   CFMutableDictionaryRef propertyDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, NULL, NULL);
   CFDictionarySetValue(propertyDict, @"HIDMouseAcceleration", number);
   
   io_connect_t connect;
   io_service_t service = IORegistryEntryFromPath(kIOMasterPortDefault, kIOServicePlane ":/IOResources/IOHIDSystem");
   kern_return_t res = IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &connect);
   
   if (!connect || res != KERN_SUCCESS)
      printf("Unable to open service\n");
   else
   {
      res = IOConnectSetCFProperties(connect, propertyDict);
      
      if (res != KERN_SUCCESS)
         printf("Failed to set mouse acceleration\n");
      else
         printf("Acceleration set to %ld\n", value);
   }
   
   IOServiceClose(connect);
   IOObjectRelease(service);
   CFRelease(propertyDict);
   
   return 0;
}

void loop()
{
   sleep(15);
   while (true)
   {
      set();
      sleep(3);
   }
}

int main(int argc, const char * argv[]) {
   @autoreleasepool {
      if (argc <= 1)
      {
         printf("fixmouse - macOS mouse acceleration killer v1.0\n");
         printf("(c) 2019 Patrick Jane - https://github.com/patrickjane/fixmouse\n");
         printf("Usage:\n");
         printf("   $ fixmouse [command]\n");
         printf("Commands:\n");
         printf("   get       - retrieves the current mouse acceleration and prints it to console\n");
         printf("   set       - kills mouse acceleration once\n");
         printf("   loop      - kills mouse acceleration repeatedly (program will not terminate)\n");
         return 1;
      }
      
      if (!strcmp(argv[1], "get"))
         return get();
      
      if (!strcmp(argv[1], "set"))
         return set();
      
      loop();
   }

   return 0;
}
