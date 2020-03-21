#include <dlfcn.h>
#include <limits.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int proc_pidpath(int pid, void *buffer, uint32_t buffersize);
bool print = true;

void printhelp() {
  printf("Used for the 'Edictus' Application. And based on gizroot for Packager by Conor. If you are seeing this menu, "
         "you are special! 😉\n\nParameters:\n --help (-h): Displays this "
         "menu\n --silent (-s): Stops all logging apart from errors or program "
         "output\n --test (-t): Only elevates permissions, no commands are "
         "run\n --status (-st): Returns 1 if root, 0 if not root.\nSyntax: "
         "edictusroot (paramaters) [command]\n");
}

void patch_libjailbreak() {
  void *handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
  if (!handle)
    if (print) {
      printf("[edictusroot] electra isnt installed, not patching\n");
    }
  return;

  if (print) {
    printf("[edictusroot] patching for electra"
           "first...\n");
  }
  // Reset errors
  dlerror();
  typedef void (*fix_setuid_prt_t)(pid_t pid);
  fix_setuid_prt_t ptr =
      (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");

  const char *dlsym_error = dlerror();
  if (dlsym_error)
    printf("[edictusroot] error when patching for electra: %s\n",
           dlsym_error);
  return;

  ptr(getpid());
  if (print) {
    printf("[edictusroot] patched\n");
  }
}

int main(int argc, char *argv[], char *envp[]) {
  // Check parent process, courtesy of
  // https://github.com/wstyres/Zebra/blob/master/Supersling/main.c
  pid_t pid = getppid();

  char buffer[4 * PATH_MAX];
  int ret = proc_pidpath(pid, buffer, sizeof(buffer));
  if (ret < 1 || strcmp(buffer, "/Applications/Edictus.app/Edictus") != 0) {
    fflush(stdout);
    printf("[edictusroot] you are not edictus...\n");
    return 1;
  }

  if (argc == 1) {
    printhelp();
    return 64;
  }

  bool hasFirstArg = false;

  if (argc > 1) {
    if (strcmp(argv[1], "--silent") == 0 || strcmp(argv[1], "-s") == 0) {
      print = false;
      hasFirstArg = true;
    }

    if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
      printhelp();
      return 0;
    }

    if (strcmp(argv[1], "--test") == 0 || strcmp(argv[1], "-t") == 0) {

      patch_libjailbreak();

      printf("[edictusroot] setting uid to 0...\n");
      setuid(0);

      if (!getuid()) {
        printf("[edictusroot] we got root! (uid is %u)\n", getuid());
        return 0;
      } else {
        printf("[edictusroot] uh oh, no root... :( (uid is %u). are permissions "
               "set correctly?\n",
               getuid());
        return 1;
      }
    }

    if (strcmp(argv[1], "--status") == 0 || strcmp(argv[1], "-st") == 0) {
      print = false;
      patch_libjailbreak();
      setuid(0);

      if (!getuid()) {
        printf("1");
        return 0;
      } else {
        printf("0");
        return 1;
      }
    }
  }

  size_t totalLength = 0;
  for (int i = (hasFirstArg ? 2 : 1); i < argc; i++) {
    totalLength += strlen(argv[i]);
    totalLength += 1;
  }

  char *c = (char *)malloc(totalLength);
  memset(c, '\0', totalLength);

  int arrayIndex = 0;
  for (int i = (hasFirstArg ? 2 : 1); i < argc; i++) {
    for (int j = 0; j < strlen(argv[i]); j++) {
      c[arrayIndex++] = argv[i][j];
    }
    if (i != argc - 1) {
      c[arrayIndex++] = ' ';
    }
  }

  patch_libjailbreak();

  if (print) {
    printf("[edictusroot] setting uid to 0...\n");
  }

  setuid(0);

  if (!getuid()) {
    if (print) {
      printf("[edictusroot] we got root! (uid is %u)\n", getuid());
      printf("[edictusroot] running command: %s\n", c);
    }

    FILE *fp;
    char path[1035];

    fp = popen(c, "r");
    if (fp == NULL) {
      printf("[edictusroot] failed to run command\n");
      return 1;
    }

    /* Read the output a line at a time - output it. */
    while (fgets(path, sizeof(path), fp) != NULL) {
      printf("%s", path);
    }

    /* close */
    pclose(fp);
    return 0;
  } else {
    if (print) {
      printf("[edictusroot] uh oh, no root... :( (uid is %u). are permissions set "
             "correctly?\n",
             getuid());
    }
    return 1;
  }
}
