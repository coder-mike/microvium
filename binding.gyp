{
  'targets': [
    {
      'target_name': 'native-vm',
      'sources': [
        'native-vm-bindings/index.cc',
        'native-vm-bindings/MicroVM.cc',
        'native-vm-bindings/Value.cc',
        'native-vm-bindings/misc.cc',
        'native-vm-bindings/WeakRef.cc',
        'native-vm/microvium.c'
      ],
      'include_dirs': [
        "<!@(node -p \"require('node-addon-api').include\")",
        "native-vm-bindings"
      ],
      'dependencies': ["<!(node -p \"require('node-addon-api').gyp\")"],
      'cflags!': [ '-fno-exceptions' ],
      'cflags_cc!': [ '-fno-exceptions' ],
      'xcode_settings': {
        'GCC_ENABLE_CPP_EXCEPTIONS': 'YES',
        'CLANG_CXX_LIBRARY': 'libc++',
        'MACOSX_DEPLOYMENT_TARGET': '10.7'
      },
      'msvs_settings': {
        'VCCLCompilerTool': { 'ExceptionHandling': 1 },
      }
    }
  ]
}