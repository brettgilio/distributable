;
;	MetaCall Distributable by Parra Studios
;	Distributable infrastructure for MetaCall.
;
;	Copyright (C) 2016 - 2020 Vicente Eduardo Ferrer Garcia <vic798@gmail.com>
;
;	Licensed under the Apache License, Version 2.0 (the "License");
;	you may not use this file except in compliance with the License.
;	You may obtain a copy of the License at
;
;		http://www.apache.org/licenses/LICENSE-2.0
;
;	Unless required by applicable law or agreed to in writing, software
;	distributed under the License is distributed on an "AS IS" BASIS,
;	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;	See the License for the specific language governing permissions and
;	limitations under the License.
;

(define-module (metacall)
  ; Guix Packages
  #:use-module (guix packages)
  #:use-module (guix modules)
  #:use-module (guix download)

  ; Build Systems
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system node)
  #:use-module (guix build json)
  #:use-module (guix build union)
  #:use-module ((guix licenses) #:prefix license:)

  ; GNU Packages
  #:use-module (gnu packages)

  ; Python Dependencies
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)

  ; Ruby Dependencies
  #:use-module (gnu packages readline)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages tcl)
  #:use-module (guix utils)

  ; NodeJS
  #:use-module (gnu packages base)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages adns)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux)

  ; Swig
  #:use-module (gnu packages swig)

  ; RapidJSON
  #:use-module (gnu packages web)

  ; NetCore Dependencies
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages mono)

  ; Cobol Dependencies
  #:use-module (gnu packages cobol)
  #:use-module (gnu packages multiprecision)
)

; NodeJS Loader Dependencies
(define-public cherow
  (package
    (name "cherow")
    (version "1.6.9")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://registry.npmjs.org/cherow/-/cherow-" version ".tgz"))
        (sha256 (base32 "1m397n6lzj49rhr8742c2cbcyqjrrxa56l197xvrx1sk4jgmzymf"))
      )
    )
    (build-system node-build-system)
    (arguments
      `(
        #:phases
        (modify-phases %standard-phases
          (delete 'check)
          (delete 'build)
        )
      )
    )
    (home-page "https://github.com/cherow/cherow")
    (synopsis "A very fast and lightweight, self-hosted javascript parser.")
    (description "A very fast and lightweight, standards-compliant,
self-hosted javascript parser with high focus on both performance and stability.")
    (license license:expat)
  )
)

; NodeJS Port Dependencies
(define-public node-addon-api
  (package
    (name "node-addon-api")
    (version "1.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/nodejs/node-addon-api/archive/" version ".tar.gz"))
        (sha256 (base32 "0i3jc5ki4dlq8l2p1wn0rw1695kr47cjx1zlkzj6h4ymzyc0i1dk"))
      )
    )
    (build-system node-build-system)
    (arguments
      `(
        #:phases
        (modify-phases %standard-phases
          (delete 'check)
        )
      )
    )
    (home-page "https://github.com/nodejs/node-addon-api/")
    (synopsis "Module for using N-API from C++")
    (description "This module contains a header-only C++ wrapper classes ...")
    (license license:expat)
  )
)

; TypeScript Loader Dependencies
(define-public typescript
  (package
    (name "typescript")
    (version "3.9.7")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://registry.npmjs.org/typescript/-/typescript-" version ".tgz"))
        (sha256 (base32 "1h0naj9x5g4lhhq4aiiqid4mvnqimjijxyni9zgphc6df91sinvd"))
      )
    )
    (build-system node-build-system)
    (arguments
      `(
        #:phases
        (modify-phases %standard-phases
          (delete 'check)
          (delete 'build)
        )
      )
    )
    (home-page "https://www.typescriptlang.org/")
    (synopsis "TypeScript extends JavaScript by adding types to the language. ")
    (description "TypeScript is a language for application-scale JavaScript.
TypeScript adds optional types to JavaScript that support tools for large-scale JavaScript applications for any browser,
for any host, on any OS. TypeScript compiles to readable, standards-based JavaScript.")
    (license license:asl2.0)
  )
)

; NodeJS
(define-public nodejs
  (package
    (name "nodejs")
    (version "10.16.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://nodejs.org/dist/v" version
                                  "/node-v" version ".tar.xz"))
              (sha256
               (base32
                "0236jlb1hxhzqjlmmlxipcycrndiq92c8434iyy7zshh3n4pzqqq"))
              (modules '((guix build utils)))
              (snippet
               `(begin
                  ;; Remove bundled software.
                  (for-each delete-file-recursively
                            '("deps/cares"
                              "deps/http_parser"
                              "deps/icu-small"
                              "deps/nghttp2"
                              "deps/openssl"
                              "deps/uv"
                              "deps/zlib"))
                  (substitute* "Makefile"
                    ;; Remove references to bundled software.
                    (("deps/http_parser/http_parser.gyp") "")
                    (("deps/uv/include/\\*.h") "")
                    (("deps/uv/uv.gyp") "")
                    (("deps/zlib/zlib.gyp") ""))
                  #t))))
    (build-system gnu-build-system)
    (arguments
     ;; TODO: Purge the bundled copies from the source.
     '(#:configure-flags '("--shared"
                           "--shared-cares"
                           "--shared-http-parser"
                           "--shared-libuv"
                           "--shared-nghttp2"
                           "--shared-openssl"
                           "--shared-zlib"
                           "--without-snapshot"
                           "--with-intl=system-icu")
       ;; Run only the CI tests.  The default test target requires additional
       ;; add-ons from NPM that are not distributed with the source.
       #:test-target "test-ci-js"
       #:tests? #f ; TODO: Enable tests by removing this line
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'patch-files
           (lambda* (#:key inputs #:allow-other-keys)
             ;; Fix hardcoded /bin/sh references.
             (substitute* '("lib/child_process.js"
                            "lib/internal/v8_prof_polyfill.js"
                            "test/parallel/test-child-process-spawnsync-shell.js"
                            "test/parallel/test-stdio-closed.js"
                            "test/sequential/test-child-process-emfile.js")
               (("'/bin/sh'")
                (string-append "'" (which "sh") "'")))

             ;; Fix hardcoded /usr/bin/env references.
             (substitute* '("test/parallel/test-child-process-default-options.js"
                            "test/parallel/test-child-process-env.js"
                            "test/parallel/test-child-process-exec-env.js")
               (("'/usr/bin/env'")
                (string-append "'" (which "env") "'")))

             ;; FIXME: These tests fail in the build container, but they don't
             ;; seem to be indicative of real problems in practice.
             (for-each delete-file
                       '("test/parallel/test-cluster-master-error.js"
                         "test/parallel/test-cluster-master-kill.js"
                         ;; See also <https://github.com/nodejs/node/issues/25903>.
                         "test/sequential/test-performance.js"))

             ;; This requires a DNS resolver.
             (delete-file "test/parallel/test-dns.js")

             ;; These tests have an expiry date: they depend on the validity of
             ;; TLS certificates that are bundled with the source.  We want this
             ;; package to be reproducible forever, so remove those.
             ;; TODO: Regenerate certs instead.
             (for-each delete-file
                       '("test/parallel/test-tls-passphrase.js"
                         "test/parallel/test-tls-server-verify.js"))
             #t))
         (replace 'configure
           ;; Node's configure script is actually a python script, so we can't
           ;; run it with bash.
           (lambda* (#:key outputs (configure-flags '()) inputs
                     #:allow-other-keys)
             (let* ((prefix (assoc-ref outputs "out"))
                    (flags (cons (string-append "--prefix=" prefix)
                                 configure-flags)))
               (format #t "build directory: ~s~%" (getcwd))
               (format #t "configure flags: ~s~%" flags)
               ;; Node's configure script expects the CC environment variable to
               ;; be set.
               (setenv "CC" (string-append (assoc-ref inputs "gcc") "/bin/gcc"))
               (apply invoke
                      (string-append (assoc-ref inputs "python")
                                     "/bin/python")
                      "configure" flags))))
         (add-after 'patch-shebangs 'patch-npm-shebang
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((bindir (string-append (assoc-ref outputs "out")
                                           "/bin"))
                    (npm    (string-append bindir "/npm"))
                    (target (readlink npm)))
               (with-directory-excursion bindir
                 (patch-shebang target (list bindir))
                 #t)))))))
    (native-inputs
     `(("python" ,python-2)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("procps" ,procps)
       ("util-linux" ,util-linux)
       ("which" ,which)))
    (native-search-paths
     (list (search-path-specification
            (variable "NODE_PATH")
            (files '("lib/node_modules")))))
    (inputs
     `(("c-ares" ,c-ares)
       ("http-parser" ,http-parser)
       ("icu4c" ,icu4c)
       ("libuv" ,libuv)
       ("nghttp2" ,nghttp2 "lib")
       ("openssl" ,openssl)
       ("zlib" ,zlib)))
    (synopsis "Evented I/O for V8 JavaScript")
    (description "Node.js is a platform built on Chrome's JavaScript runtime
for easily building fast, scalable network applications.  Node.js uses an
event-driven, non-blocking I/O model that makes it lightweight and efficient,
perfect for data-intensive real-time applications that run across distributed
devices.")
    (home-page "https://nodejs.org/")
    (license expat)
    (properties '((timeout . 3600))))) ; 1 h

; Ruby
(define-public dynruby
  (package
    (name "dynruby")
    (version "2.3.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://cache.ruby-lang.org/pub/ruby/"
                           (version-major+minor version)
                           "/ruby-" version ".tar.xz"))
       (sha256
        (base32
         "1zhxbjff08pvbnxvn58krns6q0p6g4977q6ykfn823gxhifn63wi"))
       (modules '((guix build utils)))
       (snippet `(begin
                   ;; Remove bundled libffi
                   (delete-file-recursively "ext/fiddle/libffi-3.2.1")
                   #t))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:tests? #f ; TODO: Enable tests by removing this line
       #:configure-flags
       (list
         "--enable-shared"
       )
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'replace-bin-sh-and-remove-libffi
           (lambda _
             (substitute* '("Makefile.in"
                            "ext/pty/pty.c"
                            "io.c"
                            "lib/mkmf.rb"
                            "process.c"
                            "test/rubygems/test_gem_ext_configure_builder.rb"
                            "test/rdoc/test_rdoc_parser.rb"
                            "test/ruby/test_rubyoptions.rb"
                            "test/ruby/test_process.rb"
                            "test/ruby/test_system.rb"
                            "tool/rbinstall.rb")
               (("/bin/sh") (which "sh")))
             #t)))))
    (inputs
     `(("readline" ,readline)
       ("openssl" ,openssl)
       ("bzip2" ,bzip2)
       ("libffi" ,libffi)
       ("gdbm" ,gdbm)
       ("libyaml" ,libyaml)
       ("ncurses" ,ncurses)
       ("tcl" ,tcl)
       ("tk" ,tk) ; TODO: This still fails, Ruby is not able to locate Tk/Tcl lib
       ("zlib" ,zlib)))
    (native-search-paths
     (list (search-path-specification
            (variable "GEM_PATH")
            (files (list (string-append "lib/ruby/vendor_ruby"))))))
    (synopsis "Programming language interpreter")
    (description "Ruby is a dynamic object-oriented programming language with
a focus on simplicity and productivity.")
    (home-page "https://www.ruby-lang.org")
    (license license:ruby)))

; ; NetCore SDK (https://dotnet.microsoft.com/download/dotnet-core/2.2)
; (define-public netcore-sdk
;   (package
;     (name "netcore-sdk")
;     (version "2.2.207")
;     (source
;       (origin
;         (method url-fetch)
;         (uri (string-append "https://download.visualstudio.microsoft.com/download/pr/"
;           "022d9abf-35f0-4fd5-8d1c-86056df76e89/477f1ebb70f314054129a9f51e9ec8ec"
;           "/dotnet-sdk-"
;           version
;           "-"
;           "linux-x64"
;           ".tar.gz"))
;         (sha256 (base32 "1k98p9bs0flgcfw6xiqmyxs9ipvnqrjwr4zhxv1ikq79asczpdag"))
;       )
;     )
;     (build-system binary-build-system)
;     (supported-systems '("x86_64-linux"))
;     (arguments
;      '(#:phases
;         (let ((old-patchelf (assoc-ref %standard-phases 'patchelf)))
;           (modify-phases %standard-phases
;           (replace 'unpack
;             (lambda* (#:key source #:allow-other-keys)
;               (invoke "tar" "xvf" source)))
;           (replace 'patchelf
;             (lambda args
;               (apply old-patchelf (append args (list
;               #:patchelf-plan
;                 (map (lambda (x)
;                   (list x (list "gcc:lib" "glibc" "lttng-ust" "libcurl" "openssl" "mit-krb5" "zlib" "icu4c" "libgdiplus")))
;                   (append (find-files "." "\\.so$") '("dotnet")))
;                   )))))))
;        #:system "x86_64-linux"
;        #:install-plan
;        '(("host" "host")
;         ("shared" "shared")
;         ("sdk" "sdk")
;         ("dotnet" "dotnet")
;         ("ThirdPartyNotices.txt" "share/doc/ThirdPartyNotices.txt"))
;       )
;     )
;     (inputs
;      `(("gcc:lib" ,gcc "lib")
;        ("glibc" ,glibc)
;        ("lttng-ust" ,lttng-ust)
;        ("libcurl" ,curl)
;        ("openssl" ,openssl)
;        ("mit-krb5" ,mit-krb5)
;        ("zlib" ,zlib)
;        ("icu4c" ,icu4c)
;        ("libgdiplus" ,libgdiplus)))
;     (home-page "https://dotnet.microsoft.com/")
;     (synopsis ".NET Core SDK")
;     (description ".NET Core is a free and open-source, managed computer software framework for Windows,
; Linux, and macOS operating systems. It is a cross-platform successor to .NET Framework.
; The project is primarily developed by Microsoft and released under the MIT License.")
;     (license license:expat)
;   )
; )

; ; NetCore (https://dotnet.microsoft.com/download/dotnet-core/2.2)
; (define-public netcore-runtime
;   (package
;     (name "netcore-runtime")
;     ; (version "2.1.17")
;     ; (source
;     ;   (origin
;     ;     (method url-fetch)
;     ;     (uri (string-append "https://download.visualstudio.microsoft.com/download/pr/"
;     ;       "a668ac5e-ffcc-419a-8c82-9e5feb7b2619/4108ef8aede75bbb569a359dff689c5c"
;     ;       "/dotnet-runtime-"
;     ;       version
;     ;       "-"
;     ;       "linux-x64"
;     ;       ".tar.gz"))
;     ;     (sha256 (base32 "0g7azv4f1acjsjxrqdwmsxhv6x7kgnb3kjrd624sjxq9j9ygmqpn"))
;     ;   )
;     ; )
;     (version "2.2.8")
;     (source
;       (origin
;         (method url-fetch)
;         (uri (string-append "https://download.visualstudio.microsoft.com/download/pr/"
;           "3fbca771-e7d3-45bf-8e77-cfc1c5c41810/e118d44f5a6df21714abd8316e2e042b"
;           "/dotnet-runtime-"
;           version
;           "-"
;           "linux-x64"
;           ".tar.gz"))
;         (sha256 (base32 "0vwc96jwagqxw2ybfxb932vxsa8jbd6052yfn4v40zrxac6d6igf"))
;       )
;     )
;     (build-system binary-build-system)
;     (supported-systems '("x86_64-linux"))
;     (arguments
;      '(#:phases
;         (let ((old-patchelf (assoc-ref %standard-phases 'patchelf)))
;           (modify-phases %standard-phases
;           (replace 'unpack
;             (lambda* (#:key source #:allow-other-keys)
;               (invoke "tar" "xvf" source)))
;           (replace 'patchelf
;             (lambda args
;               (apply old-patchelf (append args (list
;               #:patchelf-plan
;                 (map (lambda (x)
;                   (list x (list "gcc:lib" "glibc" "lttng-ust" "libcurl" "openssl" "mit-krb5" "zlib" "icu4c" "libgdiplus")))
;                   (append (find-files "." "\\.so$") '("dotnet")))
;                   )))))))
;        #:system "x86_64-linux"
;        #:install-plan
;        '(("host" "host")
;         ("shared" "shared")
;         ("dotnet" "dotnet")
;         ("ThirdPartyNotices.txt" "share/doc/ThirdPartyNotices.txt"))
;       )
;     )
;     (inputs
;      `(("gcc:lib" ,gcc "lib")
;        ("glibc" ,glibc)
;        ("lttng-ust" ,lttng-ust)
;        ("libcurl" ,curl)
;        ("openssl" ,openssl)
;        ("mit-krb5" ,mit-krb5)
;        ("zlib" ,zlib)
;        ("icu4c" ,icu4c)
;        ("libgdiplus" ,libgdiplus)))
;     (home-page "https://dotnet.microsoft.com/")
;     (synopsis ".NET Core")
;     (description ".NET Core is a free and open-source, managed computer software framework for Windows,
; Linux, and macOS operating systems. It is a cross-platform successor to .NET Framework.
; The project is primarily developed by Microsoft and released under the MIT License.")
;     (license license:expat)
;   )
; )

; TODO: MetaCall CLI should set some enviroment variables in order to make it work for Guixers
; See metacall/install CLI script for knowing the needed variables and paths

; MetaCall
(define-public metacall
  (package
    (name "metacall")
    (version "0.2.12")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/metacall/core/archive/v" version ".tar.gz"))
        (sha256 (base32 "183hvfy4ap2ac7vjbl267y4lnwqffzgi3c6f55bsg6lp7ddr0rjg"))
      )
    )
    (build-system cmake-build-system)
    (arguments
      `(
        #:phases
        ; TODO: This may be hidding a CMake bug with rpath on all ports, so this must be reviewed in the future
        (modify-phases %standard-phases
          (add-before 'configure 'runpath-workaround
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (setenv "LDFLAGS" (string-append "-Wl,-rpath=" out "/lib"))
                #t)))
          (add-before 'configure 'setenv
            ; TODO: Workaround for HOME directory, move this to netcore build system in the future
            (lambda _
              ; (let ((home (string-append (getenv "NIX_BUILD_TOP") "/dotnet-home")))
              (let ((home "/tmp")
                    (packages "/tmp/.nuget/packages"))
                    (setenv "DOTNET_SKIP_FIRST_TIME_EXPERIENCE" "true")
                    (setenv "HOME" home)
                    (mkdir-p home)
                    (mkdir-p packages))
            #t))
          (add-after 'build 'build-node-loader-bootstrap-cherow
            (lambda* (#:key inputs #:allow-other-keys)
              (let* ((output (string-append (getcwd) "/node_modules/cherow"))
                      (cherow (string-append (assoc-ref inputs "cherow") "/lib/node_modules/cherow/dist/commonjs/cherow.min.js")))
                (mkdir-p output)
                (copy-file cherow (string-append output "/index.js")))
              #t))
          (add-after 'build 'build-ts-loader-bootstrap-typescript
            (lambda* (#:key inputs #:allow-other-keys)
              (let* ((output (string-append (getcwd) "/node_modules/typescript"))
                      (typescript (string-append (assoc-ref inputs "typescript") "/lib/node_modules/typescript")))
                (mkdir-p output)
                (copy-recursively typescript output))
              #t)))
        ; TODO: Enable tests
        #:tests? #f
        #:configure-flags
        (list
          ; Disable developer warnings
          "-Wno-dev"

          ; Disable all unreproductible operations
          "-DOPTION_BUILD_GUIX=ON"

          ; Build wiht release mode
          "-DCMAKE_BUILD_TYPE=Release"

          ; Disable stack-smashing protection and source fortify in order to improve libc portability / compatibility
          "-DOPTION_BUILD_SECURITY=OFF"

          ; Distributable libs
          "-DOPTION_BUILD_DIST_LIBS=ON"

          ; Examples
          "-DOPTION_BUILD_EXAMPLES=ON"

          ; TODO: Enable fork safety
          "-DOPTION_FORK_SAFE=OFF"
          ; TODO: Enable tests
          "-DOPTION_BUILD_TESTS=OFF"

          ; TODO: Enable when tests
          "-DOPTION_BUILD_SCRIPTS=OFF"
          "-DOPTION_BUILD_SCRIPTS_PY=OFF"
          "-DOPTION_BUILD_SCRIPTS_RB=OFF"
          "-DOPTION_BUILD_SCRIPTS_FILE=OFF"
          "-DOPTION_BUILD_SCRIPTS_NODE=OFF"
          "-DOPTION_BUILD_SCRIPTS_CS=OFF"
          "-DOPTION_BUILD_LOADERS_JS=OFF"

          ; Serials
          "-DOPTION_BUILD_SERIALS=ON"
          "-DOPTION_BUILD_SERIALS_RAPID_JSON=ON"
          "-DOPTION_BUILD_SERIALS_METACALL=ON"

          ; Loaders
          "-DOPTION_BUILD_LOADERS=ON"
          "-DOPTION_BUILD_LOADERS_MOCK=ON"
          "-DOPTION_BUILD_LOADERS_PY=ON"
          "-DOPTION_BUILD_LOADERS_RB=ON"
          "-DOPTION_BUILD_LOADERS_FILE=ON"
          "-DOPTION_BUILD_LOADERS_NODE=ON"
          "-DOPTION_BUILD_LOADERS_TS=ON"
          "-DOPTION_BUILD_LOADERS_CS=OFF" ; TODO: Implement C# Loader
          "-DOPTION_BUILD_LOADERS_JS=OFF" ; TODO: Implement V8 Loader
          "-DOPTION_BUILD_LOADERS_COB=ON"

          ; NodeJS Addon API
          (string-append "-DNODEJS_ADDON_API_INCLUDE_DIR=" (assoc-ref %build-inputs "node-addon-api") "/lib/node_modules/node-addon-api")

          ; TODO: Avoid harcoded versions of Ruby
          (string-append "-DRUBY_EXECUTABLE=" (assoc-ref %build-inputs "dynruby") "/bin/ruby")
          (string-append "-DRUBY_INCLUDE_DIR=" (assoc-ref %build-inputs "dynruby") "/include/ruby-2.3.0")
          (string-append "-DRUBY_LIBRARY=" (assoc-ref %build-inputs "dynruby") "/lib/libruby.so")
          (string-append "-DRUBY_VERSION=" "2.3.8")

          ; TODO: Avoid harcoded versions of NodeJS
          (string-append "-DNODEJS_EXECUTABLE=" (assoc-ref %build-inputs "nodejs") "/bin/node")
          (string-append "-DNODEJS_INCLUDE_DIR=" (assoc-ref %build-inputs "nodejs") "/include/node")
          (string-append "-DNODEJS_LIBRARY=" (assoc-ref %build-inputs "nodejs") "/lib/libnode.so.64")
          "-DNODEJS_CMAKE_DEBUG=ON"
          "-DNODEJS_SHARED_UV=ON"

          ; ; TODO: Avoid harcoded versions of NetCore
          ; (string-append "-DDOTNET_COMMAND=" (assoc-ref %build-inputs "netcore-sdk") "/dotnet")
          ; ; (string-append "-DDOTNET_CORE_PATH=" (assoc-ref %build-inputs "netcore-runtime") "/shared/Microsoft.NETCore.App/2.1.17/")
          ; (string-append "-DDOTNET_CORE_PATH=" (assoc-ref %build-inputs "netcore-runtime") "/shared/Microsoft.NETCore.App/2.2.8/")

          ; TODO: Avoid harcoded versions of Cobol
          (string-append "-DCOBOL_EXECUTABLE=" (assoc-ref %build-inputs "gnucobol") "/bin/cobc")
          (string-append "-DCOBOL_INCLUDE_DIR=" (assoc-ref %build-inputs "gnucobol") "/include")
          (string-append "-DCOBOL_LIBRARY=" (assoc-ref %build-inputs "gnucobol") "/lib/libcob.so.4.0.0")

          ; TODO: Finish all loaders
          "-DOPTION_BUILD_SCRIPTS_JS=OFF"

          ; Ports
          "-DOPTION_BUILD_PORTS=ON"
          "-DOPTION_BUILD_PORTS_PY=ON"
          "-DOPTION_BUILD_PORTS_RB=ON"
          "-DOPTION_BUILD_PORTS_NODE=ON"
          "-DOPTION_BUILD_PORTS_TS=OFF" ; TODO: Not implemented yet
          "-DOPTION_BUILD_PORTS_CS=ON"

          ; Disable coverage
          "-DOPTION_COVERAGE=OFF"

          ; Python Port (Swig) requires conversion between constant to non-constant char pointer
          "-DCMAKE_CXX_FLAGS=-fpermissive"
        )
      )
    )
    (propagated-inputs
     `(
        ("python" ,python) ; Python Loader dependency
        ("dynruby" ,dynruby) ; Ruby Loader dependency
        ("nodejs" ,nodejs) ; NodeJS Loader dependency
        ("libuv" ,libuv) ; NodeJS Loader dependency
        ("cherow" ,cherow) ; NodeJS Loader dependency
        ("typescript" ,typescript) ; TypeScript Loader dependency
        ("gnucobol" ,gnucobol) ; Cobol Loader dependency
        ("gmp" ,gmp) ; Cobol Loader dependency
        ; ("netcore-runtime" ,netcore-runtime) ; NetCore Loader dependency
        ; ("netcore-sdk" ,netcore-sdk) ; NetCore Loader dependency
      )
    )
    (native-inputs
     `(
        ("rapidjson" ,rapidjson) ; RapidJson Serial dependency
        ("python2-gyp" ,python2-gyp) ; For building NodeJS Port
        ("node-addon-api" ,node-addon-api) ; For building NodeJS Port
        ("swig" ,swig) ; For building ports
      )
    )
    (home-page "https://metacall.io/")
    (synopsis "Inter-language foreign function interface call library.")
    (description "METACALL is a library that allows calling functions,
methods or procedures between programming languages.
With METACALL you can transparently execute code from / to any
programming language, for example, call Python code from NodeJS code.")
    (license license:asl2.0)
  )
)
