pragma(LDC_no_moduleinfo);
pragma(LDC_no_typeinfo);

import answers;
import peb;

import core.sys.windows.windows : GetModuleHandle, VirtualProtect, DWORD, PAGE_READWRITE;
import std.stdio : writeln, writefln, write, readln;
import std.string : strip;
import core.sys.windows.winnt;
import core.stdc.stdlib : exit;
import zero_memory;


int main()
{
    checkForNeek();
    removePEHeader();
    setSizeOfImage();

    
    write("Who needed to sell his chickens to buy a new router?\nAnswer: "); 
    if (readln.strip == skid92) {
        write(Crypt!"Correct answer!\nYour flag is: ", skidflag);
    } else { 
        write(Crypt!"Wrong answer! "); 
    }
    return 0;
}

auto getSizeOfImage()
{
    const PED = getPEB();
    auto ldrMod = cast(LDR_MODULE*) PED.Ldr.InLoadOrderModuleList.next;
    auto SizeOfImage = ldrMod.SizeOfImage;
    writefln(Crypt!"SizeOfImage %s (0x%X)", SizeOfImage, SizeOfImage);
    return SizeOfImage;
}

void setSizeOfImage()
{
    checkForNeek();
    const auto PED = getPEB();
    auto ldrMod = cast(LDR_MODULE*) PED.Ldr.InLoadOrderModuleList.next;
    ldrMod.SizeOfImage = 0x696969;
}

void checkForNeek()
{
    const PEB = getPEB();
    
    if (PEB.BeingDebugged){
        writeln(Crypt!"BEEP BEEP neek detected");
        exit(0);
    }
}

// void removePEHeader()
// {

//     DWORD dongs = 0;
//     char* pBaseAddr = cast(char*) GetModuleHandle(null);
//     VirtualProtect(pBaseAddr, 4096, PAGE_READWRITE, &dongs);
//     secureZeroMemory(pBaseAddr, pBaseAddr.sizeof);
// }

void removePEHeader(void* pBaseAddr=GetModuleHandle(null))
{
    checkForNeek();
    PIMAGE_DOS_HEADER pDosHeader = cast(PIMAGE_DOS_HEADER)pBaseAddr;
    PIMAGE_NT_HEADERS pNTHeader  = cast(PIMAGE_NT_HEADERS)(pBaseAddr + pDosHeader.e_lfanew);
    if(pNTHeader.FileHeader.SizeOfOptionalHeader)
    {
        // writeln(pNTHeader.FileHeader.SizeOfOptionalHeader);
        DWORD Protect;
        auto Size = pNTHeader.OptionalHeader.sizeof;
        VirtualProtect(pBaseAddr, Size, PAGE_EXECUTE_READWRITE, &Protect);
        secureZeroMemory(pBaseAddr, Size);
        VirtualProtect(pBaseAddr, Size, Protect, &Protect);
    }
}

// TIL you can just move it to EAX and it will return it to the function 
// in inline asm
// asm 
// {
//     mov EAX, FS:[0x30]  ; // PEB
//     mov EAX, [EAX+2]    ; // BOOL BeingDebugged
// }



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
