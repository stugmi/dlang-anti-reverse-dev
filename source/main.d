import smug.answers, smug.peb;
import core.sys.windows.windows : GetModuleHandle, VirtualProtect, DWORD, PAGE_READWRITE;
import std.stdio : writeln, writefln, write, readln;
import std.string : strip;
import zero_memory;

int main()
{

    removePEHeader();
    // getSizeOfImage();
    setSizeOfImage();
    // getSizeOfImage();

    if (checkForNeek)
    {
        writeln(loldongs!"BEEP BEEP neek detected");
        return -1;
    }

    write(loldongs!"Who needed to sell his chickens to buy a new router?\nAnswer: ");
    if (readln.strip == skid92) {
        write(loldongs!"Correct answer!\nYour flag is: ", skidflag);
    } else { 
        write(loldongs!"Wrong answer! "); 
    }

    readln;
    return 0;
}

auto getSizeOfImage()
{
    const auto PED = getPEB();
    auto ldrMod = cast(LDR_MODULE*) PED.Ldr.InLoadOrderModuleList.next;
    auto SizeOfImage = ldrMod.SizeOfImage;
    writefln(loldongs!"SizeOfImage %s (0x%X)", SizeOfImage, SizeOfImage);
    return SizeOfImage;
}

void setSizeOfImage()
{
    const auto PED = getPEB();
    auto ldrMod = cast(LDR_MODULE*) PED.Ldr.InLoadOrderModuleList.next;
    ldrMod.SizeOfImage = 0x696969;
}

void removePEHeader()
{

    DWORD loldongs = 0;
    char* pBaseAddr = cast(char*) GetModuleHandle(null);
    VirtualProtect(pBaseAddr, 4096, PAGE_READWRITE, &loldongs);
    secureZeroMemory(pBaseAddr, pBaseAddr.sizeof);
}

bool checkForNeek()
{
    auto PEB = getPEB();
    return PEB.BeingDebugged;

    // TIL you can just move it to EAX and it will return it to the function 
    // in inline asm
    // asm 
    // {
    //     mov EAX, FS:[0x30]  ; // PEB
    //     mov EAX, [EAX+2]    ; // BOOL BeingDebugged
    // }
}

// int getSizeOfImage_ASM(){
//     int sizeOfImage = 0;
//     asm {
//         mov EAX, FS:[0x30]    ;  // PEB
//         mov EAX, [EAX + 0x0c] ;  // PEB_LDR_DATA  
//         mov EAX, [EAX + 0x0c] ;  // InLoadOrderModuleList
//         mov EAX, [EAX + 0x20] ;  // sizeOfImage
//         mov sizeOfImage, EAX  ;
//     }
// }

// void setSizeOfImage_ASM()
// {
//     asm {    
//         mov EAX, FS:[0x30]                    ; // PEB
//         mov EAX, [EAX + 0x0c]                 ; // PEB_LDR_DATA
//         mov EAX, [EAX + 0x0c]                 ; // inOrderModuleList
//         mov dword ptr [EAX + 0x20], 0x1000000 ; //  
//     }
// }
