module smug.peb;

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
  LIST_ENTRY InLoadOrderModuleList;
  LIST_ENTRY InMemoryOrderModuleList;
  LIST_ENTRY InInitializationOrderModuleList;
  PVOID BaseAddress;
  PVOID EntryPoint;
  SIZE_T SizeOfImage;
  UNICODE_STRING FullDllName;
  UNICODE_STRING BaseDllName;
  ULONG Flags;
  SHORT LoadCount; // obsolete after Version 6.1
  SHORT TlsIndex;
  LIST_ENTRY HashTableEntry;
  ULONG TimeDateStamp;
  PVOID EntryPointActivationContext;
  PVOID PatchInformation;
  LDR_DDAG_NODE* DdagNode; // starting with Version 6.2
}

struct LDR_DDAG_NODE
{
  LIST_ENTRY Modules;
  void* ServiceTagList; // LDR_SERVICE_TAG_RECORD
  ULONG LoadCount;
  ULONG ReferenceCount; // Version 10: ULONG LoadWhileUnloadingCount;
  ULONG DependencyCount; // Version 10: ULONG LowestLink;
}

struct _PEB64
{
  BYTE[2] Reserved1;
  BOOLEAN BeingDebugged;
  BYTE[13] Reserved2;
  PVOID ImageBaseAddress;
  PEB_LDR_DATA Ldr;
  PVOID ProcessParameters;
  BYTE[520] Reserved3;
  PVOID PostProcessInitRoutine;
  BYTE[136] Reserved4;
  ULONG SessionId;
}
alias PEB64 = _PEB64*;

struct _PEB32
{
  BYTE[2] Reserved1;
  BOOLEAN BeingDebugged;
  BYTE[1] Reserved2;
  PVOID64 Reserved3;
  PVOID64 ImageBaseAddress;
  PEB_LDR_DATA Ldr;
  PVOID64 ProcessParameters;
  BYTE[104] Reserved4;
  PVOID64[52] Reserved5;
  PVOID64 PostProcessInitRoutine;
  BYTE[128] Reserved6;
  PVOID64[1] Reserved7;
  ULONG64 SessionId;
}
alias PEB32 = _PEB32*;

struct _PEB_LDR_DATA
{
  ULONG Length;
  BOOLEAN Initialized;
  PVOID SsHandle;
  LIST_ENTRY InLoadOrderModuleList;
  LIST_ENTRY InMemoryOrderModuleList;
  LIST_ENTRY InInitializationOrderModuleList;
}
alias PEB_LDR_DATA = _PEB_LDR_DATA*;

static auto getPEB() nothrow @nogc
{
    version (Win32)
    {
        PEB32 PEB;
        asm pure nothrow @nogc
        {
            mov EAX,FS:[0x30];
            mov PEB, EAX;
        }
        return PEB;
    }
    else version (Win64)
    {
        PEB64 PEB;
        asm pure nothrow @nogc
        {
            mov RAX,0x60;
            mov RAX,GS:[RAX]; // immediate value causes fixup
            mov PEB, RAX;
        }
        return PEB;
    }
    else
    {
        static assert(false);
    }
}
