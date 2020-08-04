pragma(LDC_no_moduleinfo);
pragma(LDC_no_typeinfo);

import core.sys.windows.windows;

alias bool BOOLEAN;
struct UNICODE_STRING
{
  short Length;
  short MaximumLength;
  wchar* Buffer;
}

struct LIST_ENTRY
{
  LIST_ENTRY* next;
  LIST_ENTRY* prev;
}

// the following structures can be found here:
// https://www.geoffchappell.com/studies/windows/win32/ntdll/structs/ldr_data_table_entry.htm
// perhaps this should be same as LDR_DATA_TABLE_ENTRY, which is introduced with PEB_LDR_DATA
struct LDR_MODULE
{
  LIST_ENTRY        InLoadOrderModuleList;
  LIST_ENTRY        InMemoryOrderModuleList;
  LIST_ENTRY        InInitializationOrderModuleList;
  PVOID             BaseAddress;
  PVOID             EntryPoint;
  SIZE_T            SizeOfImage;
  UNICODE_STRING    FullDllName;
  UNICODE_STRING    BaseDllName;
  ULONG             Flags;
  SHORT             LoadCount;
  SHORT             TlsIndex;
  LIST_ENTRY        HashTableEntry;
  ULONG             TimeDateStamp;
  PVOID             EntryPointActivationContext;
  PVOID             PatchInformation;
  LDR_DDAG_NODE*    DdagNode;
}

struct LDR_DDAG_NODE
{
  LIST_ENTRY  Modules;
  void*       ServiceTagList; // LDR_SERVICE_TAG_RECORD
  ULONG       LoadCount;
  ULONG       ReferenceCount; // Version 10: ULONG LoadWhileUnloadingCount;
  ULONG       DependencyCount; // Version 10: ULONG LowestLink;
}

struct _PEB64
{
  BYTE[2]       Reserved1;
  BOOLEAN       BeingDebugged;
  BYTE[13]      Reserved2;
  PVOID         ImageBaseAddress;
  PEB_LDR_DATA  Ldr;
  PVOID         ProcessParameters;
  BYTE[520]     Reserved3;
  PVOID         PostProcessInitRoutine;
  BYTE[136]     Reserved4;
  ULONG         SessionId;
}
alias PEB64 = _PEB64*;

struct _PEB32
{
  BYTE[2]       Reserved1;
  BOOLEAN       BeingDebugged;
  BYTE[1]       Reserved2;
  PVOID64       Reserved3;
  PVOID64       ImageBaseAddress;
  PEB_LDR_DATA  Ldr;
  PVOID64       ProcessParameters;
  BYTE[104]     Reserved4;
  PVOID64[52]   Reserved5;
  PVOID64       PostProcessInitRoutine;
  BYTE[128]     Reserved6;
  PVOID64[1]    Reserved7;
  ULONG64       SessionId;
}
alias PEB32 = _PEB32*;

struct _PEB_LDR_DATA
{
  ULONG       Length;
  BOOLEAN     Initialized;
  PVOID       SsHandle;
  LIST_ENTRY  InLoadOrderModuleList;
  LIST_ENTRY  InMemoryOrderModuleList;
  LIST_ENTRY  InInitializationOrderModuleList;
}
alias PEB_LDR_DATA = _PEB_LDR_DATA*;

static auto getPEB() nothrow
{
    version (Win32)
    {
        PEB32 PEB;
        asm pure nothrow
        {
            mov EAX, FS:[0x30];
            mov PEB, EAX;
        }
        return PEB;
    }
    else version (Win64)
    {
        PEB64 PEB;
        asm pure nothrow
        {
            mov RAX, 0x60;
            mov RAX, GS:[RAX]; // immediate value causes fixup
            mov PEB, RAX;
        }
        return PEB;
    }
    else
    {
        static assert(false);
    }
}



template IncPtr(T){ T* IncPtr(T* Ptr, int Increment) {
    return cast(T*)(cast(ubyte*)Ptr + Increment);
}}


// struct IMAGE_DOS_HEADER
// {
// 	WORD e_magic,
// 		e_cblp,
// 		e_cp,
// 		e_crlc,
// 		e_cparhdr,
// 		e_minalloc,
// 		e_maxalloc,
// 		e_ss,
// 		e_sp,
// 		e_csum,
// 		e_ip,
// 		e_cs,
// 		e_lfarlc,
// 		e_ovno;
	
// 	WORD[4] e_res;
// 	WORD e_oemid,
// 		e_oeminfo;
	
// 	WORD[10] e_res2;
// 	LONG e_lfanew;
// }
// alias PIMAGE_DOS_HEADER = IMAGE_DOS_HEADER*;

// struct IMAGE_FILE_HEADER 
// {
// 	WORD Machine, 
// 		NumberOfSections;
// 	DWORD TimeDateStamp,
// 		PointerToSymbolTable,
// 		NumberOfSymbols;
// 	WORD SizeOfOptionalHeader,
// 		Characteristics;
// }
// alias PIMAGE_FILE_HEADER = IMAGE_FILE_HEADER*;

// struct IMAGE_DATA_DIRECTORY
// {
// 	DWORD VirtualAddress, Size;
// }
// alias PIMAGE_DATA_DIRECTORY = IMAGE_DATA_DIRECTORY*; 

// struct IMAGE_OPTIONAL_HEADER32
// {
// 	//
// 	// Standard fields.
// 	//
	
// 	WORD Magic;
// 	BYTE MajorLinkerVersion, MinorLinkerVersion;
// 	DWORD SizeOfCode,
// 		SizeOfInitializedData,
// 		SizeOfUninitializedData,
// 		AddressOfEntryPoint,
// 		BaseOfCode,
// 		BaseOfData;
	
// 	//	// NT additional fields.
// 	//
	
// 	DWORD ImageBase,
// 		SectionAlignment,
// 		FileAlignment;
// 	WORD MajorOperatingSystemVersion,
// 		MinorOperatingSystemVersion;
// 	WORD MajorImageVersion,
// 		MinorImageVersion,
// 		MajorSubsystemVersion,
// 		MinorSubsystemVersion;
// 	DWORD Win32VersionValue,
// 	 	SizeOfImage,
// 	 	SizeOfHeaders,
// 	 	CheckSum;
// 	WORD Subsystem,
// 		DllCharacteristics;
// 	DWORD SizeOfStackReserve,
// 		SizeOfStackCommit,
// 		SizeOfHeapReserve,
// 		SizeOfHeapCommit,
// 		LoaderFlags,
// 		NumberOfRvaAndSizes;
// 	IMAGE_DATA_DIRECTORY[16] DataDirectory;
// }
// alias PIMAGE_OPTIONAL_HEADER32 = IMAGE_OPTIONAL_HEADER32*;

// struct IMAGE_NT_HEADERS32
// {
// 	DWORD Signature;
// 	IMAGE_FILE_HEADER FileHeader;
// 	IMAGE_OPTIONAL_HEADER32 OptionalHeader;
// }
// alias PIMAGE_NT_HEADERS32 = IMAGE_NT_HEADERS32*;

// struct IMAGE_SECTION_HEADER
// {
// 	@disable this();
// 	BYTE[8] Name;
// 	union
// 	{
// 		DWORD PhysicalAddress,
// 			VirtualSize;
// 	}
// 	DWORD VirtualAddress,
// 		SizeOfRawData,
// 		PointerToRawData,
// 		PointerToRelocations,
// 		PointerToLinenumbers;
// 	WORD NumberOfRelocations,
// 		NumberOfLinenumbers;
// 	DWORD Characteristics;
// }
// alias PIMAGE_SECTION_HEADER = IMAGE_SECTION_HEADER*;

// struct IMAGE_IMPORT_DESCRIPTOR
// {
// 	union
// 	{
// 		DWORD   Characteristics;            // 0 for terminating null import descriptor
// 		DWORD   OriginalFirstThunk;         // RVA to original unbound IAT (PIMAGE_THUNK_DATA)
// 	}
// 	DWORD   TimeDateStamp,                  // 0 if not bound,
// 	// -1 if bound, and real date\time stamp
// 	//     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
// 	// O.W. date/time stamp of DLL bound to (Old BIND)
	
// 	  ForwarderChain,                 // -1 if no forwarders
// 	  Name,
// 	  FirstThunk;                     // RVA to IAT (if bound this IAT has actual addresses)
// }
// alias PIMAGE_IMPORT_DESCRIPTOR = IMAGE_IMPORT_DESCRIPTOR*;

// __gshared ubyte[0x800] image;
