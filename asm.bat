: " In sh this syntax begins a multiline comment, whereas in batch it's a valid label that gets ignored.
@goto batch_bootstrap_builder "
if false; then */
#error Remember to insert "#if 0" into the compiler input pipe or skip the first 6 lines when compiling this file.
// Notepad++ run command: cmd /c 'cd /d $(CURRENT_DIRECTORY) &amp;&amp; $(FULL_CURRENT_PATH)'
#endif // GOTO_BOOTSTRAP_BUILDER

///////////////////////////////////////////////////////////////////////////////

#ifdef BOOTSTRAP_BUILDER
/*
fi # sh_bootstrap_builder

# Did you know that hashbang doesn't have to be on the first line of a file? Wild, right!
#!/usr/bin/env sh

compiler_executable=gcc
me=`basename "$0"`
no_ext=`echo "$me" | cut -d'.' -f1`
executable="${no_ext}.exe"

echo "static const char* b_source_filename = \"$me\";
#line 1 \"$me\"
#if GOTO_BOOTSTRAP_BUILDER /*" | cat - $me | $compiler_executable -x c -o $executable -DHELLO_WORLD -

compiler_exit_status=$?
if test $compiler_exit_status -ne 0; then echo "Failed to compile $me. Exit code: $compiler_exit_status"; exit $compiler_exit_status; fi

chmod +x $executable
./$executable

execution_exit_status=$?
if test $execution_exit_status -ne 0; then echo "$executable exited with status $execution_exit_status"; exit $execution_exit_status; fi

# -run -bench -nostdlib -lmsvcrt(?) -nostdinc -Iinclude
exit 0

///////////////////////////////////////////////////////////////////////////////

:batch_bootstrap_builder
@echo off
set compiler_executable=tcc\tcc.exe
set compiler_zip_name=tcc-0.9.27-win64-bin.zip
set download_tcc=n
if not exist %compiler_executable% if not exist %compiler_zip_name% set /P download_tcc="Download Tiny C Compiler? Please, try to avoid unnecessary redownloading. [y/n] "

if not exist %compiler_executable% (
	if not exist %compiler_zip_name% (
		if %download_tcc% == y (
			powershell -Command "Invoke-WebRequest http://download.savannah.gnu.org/releases/tinycc/%compiler_zip_name% -OutFile %compiler_zip_name%"
			if exist %compiler_zip_name% (
				echo Download complete!
			) else (
				echo Failed to download %compiler_zip_name%
			)
		)

		if not exist %compiler_zip_name% (
			echo Download Tiny C Compiler manually from http://download.savannah.gnu.org/releases/tinycc/ and unzip it here.
			pause
			exit 1
		)
	)

	if not exist tcc (
		echo Unzipping %compiler_zip_name%
		powershell Expand-Archive %compiler_zip_name% -DestinationPath .

		if exist %compiler_executable% (
			echo It seems the %compiler_zip_name% contained the %compiler_executable% directly. Thats cool.
		) else if not exist tcc (
			echo Unzipping %compiler_zip_name% did not yield the expected "tcc" folder.
			echo Move the contents of the archive here manually so that tcc.exe is in the same folder as %~n0%~x0.
			pause
			exit 1
		)
	)

	echo Tiny C Compiler Acquired!
)

(
	echo static const char* b_source_filename = "%~n0%~x0";
	echo #line 0 "%~n0%~x0"
	echo #if GOTO_BOOTSTRAP_BUILDER
	type %~n0%~x0
) | %compiler_executable% -run -DSHARED_PREFIX -DSOURCE -bench -Itcc/libtcc -lmsvcrt -lkernel32 -luser32 -lgdi32 -Ltcc/libtcc -llibtcc -
rem ) | %compiler_executable% -o%~n0.exe -DSHARED_PREFIX -DSOURCE -bench -Itcc/libtcc -lmsvcrt -lkernel32 -luser32 -lgdi32 -Ltcc/libtcc -llibtcc -
rem ) | %compiler_executable% -run -nostdinc -lmsvcrt -lkernel32 -luser32 -lgdi32 -Itcc/include -Itcc/include/winapi -Itcc/libtcc -Ltcc/libtcc -llibtcc -DSHARED_PREFIX -DSOURCE -bench -


echo.

if %errorlevel% == 0 (
	echo Finished without errors!
) else (
	if %errorlevel% == -1073740940 (
		echo %errorlevel% - Critical error detected C0000374
	) else (
		if %errorlevel% == -1073741819 (
			echo %errorlevel% - Access right violation C0000005
		) else (
			if %errorlevel% == -1073740771 (
				echo %errorlevel% - STATUS_FATAL_USER_CALLBACK_EXCEPTION C000041D
			) else (
				echo Finished with error %errorlevel%
			)
		)
	)
	goto end
)

%~n0.exe

:end
exit errorlevel

*/
#endif // BOOTSTRAP_BUILDER

///////////////////////////////////////////////////////////////////////////////

#ifdef SHARED_PREFIX

enum { TRACE=1, TRACE_VERBOSE=0 };

#define trace_printf(...) do { if (TRACE) printf(__VA_ARGS__); } while(0)
#define trace_func() trace_printf("%s, ", __FUNCTION__)
#define trace_func_end() trace_printf("%s end, ", __FUNCTION__)

#define verbose_printf(...) do { if (TRACE_VERBOSE) printf(__VA_ARGS__); } while(0)
#define verbose_func() verbose_printf("%s, ", __FUNCTION__)
#define verbose_func_end() verbose_printf("%s end, ", __FUNCTION__)

#define FATAL(x, ...) do { if (x) break; fprintf(stderr, "%s:%d: (" SEGMENT_NAME "/%s) FATAL: ", __FILE__, __LINE__, __FUNCTION__); fprintf(stderr, __VA_ARGS__ ); fprintf(stderr, "\n(%s)\n", #x); int system(const char*); system("pause"); void exit(int); exit(-54746); } while(0)

typedef struct
{
	int stop;
	int skip;
	int redraw_requested;
	int ghost_frame;
	signed long long time_us;
	unsigned long long input_buffer_size;
	char* input_buffer;
	unsigned long long user_buffer_size;
	char* user_buffer;
} Communication;

typedef struct
{
	void (*get_screen_width_and_height)(void* drawer, int* screen_width, int* screen_height);
	void (*rect)(void* drawer, int x, int y, int w, int h, int r, int g, int b);
	void (*text)(void* drawer, int x, int y, char* str, int strLen);
	void (*fill)(void* drawer, int r, int g, int b);
	void (*pixel)(void* drawer, int x, int y, int r, int g, int b);
	void (*text_w)(void* drawer, int x, int y, unsigned short* str, int strLen);
} Drawer_Funcs;

#endif // SHARED_PREFIX

///////////////////////////////////////////////////////////////////////////////

#ifdef SOURCE
#define SEGMENT_NAME "SOURCE"

#define nullptr ((void*)0)

struct Symbol
{
	void* address;
	const char* name;
};

struct Symbols
{
	void* address[1024];
	const char* name[1024];
	int count;
};
#define PUSH(p_symbols, p_name, p_address) do { struct Symbols* __symbols = (p_symbols); int i = __symbols->count++; __symbols->address[i] = (p_address); __symbols->name[i] = (p_name); } while(0)

struct Symbols g_functions;

struct Scope
{
	void* pc;
	void* rbp;
	struct Scope* parent;
	struct Symbols symbols;
} g_globals = {.pc = (void*)-1, .rbp = (void*)-1, nullptr, {0}}, *g_current_scope = &g_globals;


#define STRINGIFY2(x) #x 
#define STRINGIFY(x) STRINGIFY2(x)

#define ADD_FUNCTION(p_name) PUSH(&g_functions, STRINGIFY(p_name), &(p_name))
#define ADD_GLOBAL_VARIABLE(p_name) PUSH(&g_globals.symbols, STRINGIFY(p_name), &(p_name))
#define ADD_GLOBAL_VARIABLE(p_name) PUSH(&g_globals.symbols, STRINGIFY(p_name), &(p_name))

#include <stdio.h>
#include <stdlib.h>
//#include <sys/stat.h>
//#include <time.h>

#if defined(_MSC_VER)
    #define GET_PC(p_pc) __asm { lea p_pc, [__current_pc] }
    #define GET_RETURN_ADDRESS(p_rbp) asm volatile ("movq %%rbp, %0;" : "=r" (p_rbp))
    #define GET_BASE_POINTER(p_rbp) asm volatile ("movq %%rbp, %0;" : "=r" (p_rbp))
#else
	#define GET_PC(p_pc) asm volatile ("lea (%%rip), %0" : "=r" (p_pc))
	#define GET_BASE_POINTER(p_rbp) asm volatile ("movq %%rbp, %0;" : "=r" (p_rbp))
	#define GET_RETURN_ADDRESS(p_rbp) asm volatile ("movq %%rbp, %0;" : "=r" (p_rbp))
	#define GET_STACK_POINTER(p_rsp) asm volatile ("movq %%rsp, %0;" : "=r" (p_rsp))
#endif

const char* findFunctionName(void* pc)
{
	if (pc < g_functions.address[0])
		return "<BELOW ADDRESS SPACE>";

	if (pc > g_functions.address[g_functions.count - 1] + 1024)
		return "<ABOVE ADDRESS SPACE>";

	for (int i = 1; i < g_functions.count; ++i)
	{
		if (g_functions.address[i] > pc)
			return g_functions.name[i - 1];
	}
	return g_functions.name[g_functions.count - 1];
}

void* g_stack = (void*)-1;
void* g_offset = (void*)-1; // Beginning of the first debuggable function

void printStack(void** ras)
{
	for (int i = -5; i < 5; ++i)
	{
		printf("  %s(%4X)\n", findFunctionName(ras[i]), ras[i] - g_offset);
	}
}

#define PRINT_REGISTERS() do {\
    void* pc; \
	void* rbp; \
	void* rsp; \
	GET_PC(pc); \
	GET_RETURN_ADDRESS(rbp); \
	GET_STACK_POINTER(rsp); \
    printf("%s(%d)%s: PC=%X, rbp=%X, rsp=%X\n", __FILE__, __LINE__, __FUNCTION__, pc - g_offset, g_stack - rbp, g_stack - rsp); \
	/*printStack(ras);*/ \
} while(0)

#define PRINT_LOCATION PRINT_REGISTERS

void bbb();
void aaa();

#include <windows.h>

void printCallstack(void)
{
	// No need to print "printCallstack" every time
	//void** pc; GET_PC(pc); printf("  %s (%X)\n", findFunctionName(pc), pc - g_offset);

	void** rbp;
	GET_BASE_POINTER(rbp);
	while (rbp <= g_stack) {
		void* ret = rbp[1];
		printf("  %s (%X)\n", findFunctionName(ret), ret - g_offset);
		rbp = (void**)rbp[0];
	}
}

void ccc()
{
	int eka = 123;
	int toka = 456;
	void** rbp;
	void** rsp;
	GET_RETURN_ADDRESS(rbp);
	GET_RETURN_ADDRESS(rsp);

	printCallstack();

	void** caller_rbp = (void**)rbp[0];
	void* ret = rbp[1];

	void** ccaller_rbp = (void**)caller_rbp[0];
	void* caller_ret = caller_rbp[1];

	void** cccaller_rbp = (void**)ccaller_rbp[0];
	void* ccaller_ret = ccaller_rbp[1];

	void** ccccaller_rbp = (void**)cccaller_rbp[0];
	void* cccaller_ret = cccaller_rbp[1];


	printf(">>>>>>>>>>>>> %p\n", g_stack - caller_rbp);
	printf(">>>>>>>>>>>>> %p, %s\n", ret - g_offset, findFunctionName(ret));

	printf(">>>>>>>>>>>>> %p\n", g_stack - ccaller_rbp);
	printf(">>>>>>>>>>>>> %p, %s\n", caller_ret - g_offset, findFunctionName(caller_ret));

	printf(">>>>>>>>>>>>> %p\n", cccaller_rbp);
	printf(">>>>>>>>>>>>> %p, %s\n", ccaller_ret - g_offset, findFunctionName(ccaller_ret));

	printf(">>>>>>>>>>>>> %p\n", ccccaller_rbp);
	printf(">>>>>>>>>>>>> %p, %s\n", cccaller_ret - g_offset, findFunctionName(cccaller_ret));
	
	
	printf("%s %p\n", __FUNCTION__, __FUNCTION__);

	exit(22);

	printf(">>>>>>>>>>>>> %d\n", (char*)&eka - (char*)rbp);
	printf(">>>>>>>>>>>>> %d\n", *(((int*)rbp)-1));
	printf(">>>>>>>>>>>>> %d\n", *(((int*)rbp)-2));
	printf(">>>>>>>>>>>>> %lld\n", *(((long long*)(((int*)rbp)-2)) - 1));
	printf(">>>>>>>>>>>>> %lld\n", rbp);
	printf(">>>>>>>>>>>>> my rbp: %X\n", g_stack - rbp);
	printf(">>>>>>>>>>>>> my rsp: %X\n", g_stack - rsp);
	printf(">>>>>>>>>>>>> my ret: %X  == %s\n", ret - g_offset, findFunctionName(ret));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  g_stack - (rbp + 2));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  g_stack - (rbp + 4));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  g_stack - (rbp + 6));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  g_stack - (rbp + 8));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  g_stack - (rbp + 16));
	printf(">>>>>>>>>>>>> caller rsp: %X\n",  (rbp + 16));
	exit(1);
	
	unsigned char i[10] = {1,2,3,4,5,6,7,8,9};
	PRINT_LOCATION();
	int j[1024] = {0};
	//PRINT_LOCATION();
}

void bbb() {
	printf("%s %p\n", __FUNCTION__, __FUNCTION__);

	PRINT_LOCATION();
	int i[1024] = {0};
	PRINT_LOCATION();
	ccc();
}

void aaa() {
	printf("%s %p\n", __FUNCTION__, __FUNCTION__);

	PRINT_LOCATION();
	int i[1024] = {0};
	PRINT_LOCATION();
	bbb();
	ccc();
	bbb();
	ccc();
}

void run()
{
	GET_BASE_POINTER(g_stack);

	void initDebugger();
	initDebugger();

	trace_printf("_start()\n");

	//SetUnhandledExceptionFilter((LPTOP_LEVEL_EXCEPTION_FILTER)&exception_handler);

	PRINT_LOCATION();

	aaa();
    bbb();
    ccc();

	trace_printf("\nBye!\n");

	exit(69);
}

//LONG exception_handler(LPEXCEPTION_POINTERS p)
//{
//	FATAL(0, "Exception!!!\n");
//	return EXCEPTION_EXECUTE_HANDLER;
//}

void _start()
{
	run();
}

void _runmain() { run(); }

void initDebugger()
{
	ADD_FUNCTION(initDebugger);
	ADD_FUNCTION(run);
	ADD_FUNCTION(aaa);
	ADD_FUNCTION(bbb);
	ADD_FUNCTION(ccc);
	ADD_FUNCTION(_start);
	ADD_FUNCTION(_runmain);
	ADD_FUNCTION(printCallstack);

	// bubble sort for the ultimate performance
	for (int i = 0; i < g_functions.count; ++i)
	{
		for (int j = i+1; j < g_functions.count; ++j)
		{
			if (g_functions.address[i] > g_functions.address[j])
			{
				void* t = g_functions.address[i];
				g_functions.address[i] = g_functions.address[j];
				g_functions.address[j] = t;
				
				const char* n = g_functions.name[i];
				g_functions.name[i] = g_functions.name[j];
				g_functions.name[j] = n;
				
			}
		}
	}

	g_offset = g_functions.address[0];
	for (int i = 0; i < g_functions.count; ++i)
	{
		printf("%4X> %s\n", g_functions.address[i] - g_offset, g_functions.name[i]);
	}
}

#endif // SOURCE
