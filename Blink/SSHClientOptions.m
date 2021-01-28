//////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016-2018 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////

#import "SSHClientOptions.h"
#import "BKDefaults.h"
#import "BKHosts.h"
#import "BKPubKey.h"
#import "BlinkPaths.h"
#import "bk_getopts.h"
#import <ios_system/ios_system.h>

const NSString *SSHOptionStrictHostKeyChecking = @"stricthostkeychecking";
const NSString *SSHOptionHostName = @"hostname";
const NSString *SSHOptionPort = @"port";                 // -p
const NSString *SSHOptionLogLevel = @"loglevel";         // -v
const NSString *SSHOptionIdentityFile = @"identityfile"; // -i
const NSString *SSHOptionRequestTTY = @"requesttty";     // -tT
const NSString *SSHOptionUser = @"user";                 // -l
const NSString *SSHOptionProxyCommand = @"proxycommand"; // ?
const NSString *SSHOptionConfigFile = @"configfile";     // -F
const NSString *SSHOptionRemoteCommand = @"remotecommand";
const NSString *SSHOptionConnectTimeout = @"connecttimeout";         // -o
const NSString *SSHOptionConnectionAttempts = @"connectionattempts"; // -o
const NSString *SSHOptionCompression = @"compression";               //-C -o
const NSString *SSHOptionCompressionLevel = @"compressionlevel";     // -o
const NSString *SSHOptionTCPKeepAlive = @"tcpkeepalive";
const NSString *SSHOptionNumberOfPasswordPrompts =
    @"numberofpasswordprompts";                                        // -o
const NSString *SSHOptionServerAliveCountMax = @"serveralivecountmax"; // -o
const NSString *SSHOptionServerAliveInterval = @"serveraliveinterval"; // -o
const NSString *SSHOptionLocalForward = @"localforward";               // -L
const NSString *SSHOptionRemoteForward = @"remoteforward";             // -R
const NSString *SSHOptionForwardAgent = @"forwardagent";               // -a -A
const NSString *SSHOptionForwardX11 = @"forwardx11";                   // -x -X
const NSString *SSHOptionExitOnForwardFailure = @"exitonforwardfailure"; // -o
const NSString *SSHOptionSendEnv = @"sendenv";                           // -o

// Auth

const NSString *SSHOptionKbdInteractiveAuthentication =
    @"kbdinteractiveauthentication";                                     // -o
const NSString *SSHOptionPubkeyAuthentication = @"pubkeyauthentication"; // -o
const NSString *SSHOptionPasswordAuthentication =
    @"passwordauthentication";                               // -o
const NSString *SSHOptionIdentitiesOnly = @"identitiesonly"; // -o

// Non standart
const NSString *SSHOptionPassword = @"_password";                     //
const NSString *SSHOptionPrintConfiguration = @"_printconfiguration"; // -G
const NSString *SSHOptionPrintVersion = @"_printversion";             // -V
const NSString *SSHOptionSTDIOForwarding = @"_stdioforwarding";       // -W
const NSString *SSHOptionPrintAddress = @"_printaddress";             // -o

const NSString *SSHOptionValueYES = @"yes";
const NSString *SSHOptionValueNO = @"no";
const NSString *SSHOptionValueASK = @"ask";
const NSString *SSHOptionValueAUTO = @"auto";
const NSString *SSHOptionValueANY = @"any";
const NSString *SSHOptionValueNONE = @"none";

// QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG1, DEBUG2, and DEBUG3.
const NSString *SSHOptionValueQUIET = @"quiet";
const NSString *SSHOptionValueFATAL = @"fatal";
const NSString *SSHOptionValueERROR = @"error";
const NSString *SSHOptionValueINFO = @"info";
const NSString *SSHOptionValueVERBOSE = @"verbose";

const NSString *SSHOptionValueDEBUG = @"debug";
const NSString *SSHOptionValueDEBUG1 = @"debug1";
const NSString *SSHOptionValueDEBUG2 = @"debug2";
const NSString *SSHOptionValueDEBUG3 = @"debug3";

@implementation SSHClientOptions {
  NSMutableDictionary *_options;
  int _exitCode;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _options = [[NSMutableDictionary alloc] init];
    _exitCode = SSH_OK;
  }

  return self;
}

- (int)_exitWithCode:(int)code andMessage:(NSString *)message {
  _exitCode = code;
  _exitMessage = message;
  return code;
}

- (NSMutableDictionary *)_applyOptions:(NSArray *)options
                                toArgs:(NSDictionary *)args {

  NSObject *stringType = [[NSObject alloc] init];
  NSObject *yesNoType = [[NSObject alloc] init];
  NSObject *yesNoAutoType = [[NSObject alloc] init];
  NSObject *yesNoAskType = [[NSObject alloc] init];
  NSObject *portType = [[NSObject alloc] init];
  NSObject *intType = [[NSObject alloc] init];
  NSObject *intNoneType = [[NSObject alloc] init];
  NSObject *identityfileType = [[NSObject alloc] init];
  NSObject *sendEnvType = [[NSObject alloc] init];
  NSObject *localforwardType = [[NSObject alloc] init];
  NSObject *remoteforwardType = [[NSObject alloc] init];
  NSObject *logLevelType = [[NSObject alloc] init];
  NSObject *compressionLevelType = [[NSObject alloc] init];
  NSObject *hostportType = [[NSObject alloc] init];

  NSArray *userOption = @[ stringType ];

  NSDictionary *opts = @{
    SSHOptionUser : userOption,
    SSHOptionHostName : @[ stringType ],
    SSHOptionPort : @[ portType, @(22) ],
    SSHOptionRequestTTY : @[ yesNoAutoType, SSHOptionValueAUTO ],
    SSHOptionTCPKeepAlive : @[ yesNoType, SSHOptionValueYES ],
    SSHOptionConnectionAttempts : @[ intType, @(1) ],
    SSHOptionNumberOfPasswordPrompts : @[ intType, @(3) ],
    SSHOptionServerAliveCountMax : @[ intType, @(3) ],
    SSHOptionServerAliveInterval : @[ intType, @(0) ],
    SSHOptionRemoteCommand : @[ stringType ],
    SSHOptionConnectTimeout : @[ intType, @(20) /*SSHOptionValueNONE*/ ],
    SSHOptionIdentityFile : @[
      identityfileType, @[ @"id_rsa", @"id_dsa", @"id_ecdsa", @"id_ed25519" ]
    ],
    SSHOptionLocalForward : @[ localforwardType ],
    SSHOptionRemoteForward : @[ remoteforwardType ],
    SSHOptionProxyCommand : @[ stringType ],
    SSHOptionForwardAgent : @[ yesNoType, SSHOptionValueNO ],
    SSHOptionForwardX11 : @[ yesNoType, SSHOptionValueNO ],
    SSHOptionStrictHostKeyChecking : @[ yesNoAskType, SSHOptionValueASK ],
    SSHOptionExitOnForwardFailure : @[ yesNoType, SSHOptionValueNO ],
    SSHOptionSendEnv : @[ sendEnvType ], // LANG LC_* in os x ssh client
    SSHOptionLogLevel : @[ logLevelType, SSHOptionValueINFO ],
    SSHOptionCompression : @[
      yesNoType, SSHOptionValueYES
    ], // We mobile terminal, so we set compression to yes by default.
    SSHOptionCompressionLevel :
        @[ compressionLevelType, @(6) ], // Default compression for speed
    SSHOptionSTDIOForwarding : @[ hostportType ],
    SSHOptionPrintAddress : @[ yesNoType, SSHOptionValueNO ],

    // Auth
    SSHOptionPubkeyAuthentication : @[ yesNoType, SSHOptionValueYES ],
    SSHOptionKbdInteractiveAuthentication : @[ yesNoType, SSHOptionValueYES ],
    SSHOptionPasswordAuthentication : @[ yesNoType, SSHOptionValueYES ],
    SSHOptionIdentitiesOnly : @[ yesNoType, SSHOptionValueNO ]
  };

  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

  // Set defaults:
  for (NSString *key in opts.allKeys) {
    NSArray *vals = opts[key];
    if (vals.count >= 2) {
      result[key] = vals[1];
    }
  }

  NSMutableArray<NSString *> *identityfileOption =
      [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *localforwardOption =
      [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *remoteforwardOption =
      [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *sendEnvOption = [[NSMutableArray alloc] init];

  // Set options:
  for (NSString *optionStr in options) {
    NSArray *parts = [optionStr componentsSeparatedByString:@"="];

    if (parts.count == 1) {
      [self _exitWithCode:SSH_ERROR andMessage:@"Missing argument."];
      return result;
    }

    NSString *key = [parts.firstObject lowercaseString];
    NSArray *vals = opts[key];
    if (vals == nil) {
      [self
          _exitWithCode:SSH_ERROR
             andMessage:[NSString
                            stringWithFormat:@"Bad configuration option: '%@'",
                                             key]];
      return result;
    }

    NSObject *type = vals[0];
    NSString *value = parts[1];
    NSString *lv = [value lowercaseString];

    if (type == stringType) {
      result[key] = value; // TODO: strip qoutes
    } else if (type == identityfileType) {
      [identityfileOption addObject:value];
    } else if (type == localforwardType) {
      [localforwardOption addObject:value];
    } else if (type == remoteforwardType) {
      [remoteforwardOption addObject:value];
    } else if (type == sendEnvType) {
      [sendEnvOption addObject:value];
    } else if (type == yesNoType) {
      if ([@[ SSHOptionValueYES, SSHOptionValueNO ] indexOfObject:lv] ==
          NSNotFound) {
        [self _exitWithCode:SSH_ERROR
                 andMessage:[NSString
                                stringWithFormat:@"unsupported option \"%@\".",
                                                 key]];
        return result;
      }
      result[key] = lv;
    } else if (type == yesNoAutoType) {
      if ([@[ SSHOptionValueYES, SSHOptionValueNO, SSHOptionValueAUTO ]
              indexOfObject:lv] == NSNotFound) {
        [self _exitWithCode:SSH_ERROR
                 andMessage:[NSString
                                stringWithFormat:@"unsupported option \"%@\".",
                                                 key]];
        return result;
      }
      result[key] = lv;
    } else if (type == yesNoAskType) {
      if ([@[ SSHOptionValueYES, SSHOptionValueNO, SSHOptionValueASK ]
              indexOfObject:lv] == NSNotFound) {
        [self _exitWithCode:SSH_ERROR
                 andMessage:[NSString
                                stringWithFormat:@"unsupported option \"%@\".",
                                                 key]];
        return result;
      }
      result[key] = lv;
    } else if (type == intNoneType) {
      if ([SSHOptionValueNONE isEqualToString:lv]) {
        result[key] = lv;
      } else {
        int v = 0;
        NSScanner *scanner = [NSScanner scannerWithString:lv];
        if ([scanner scanInt:&v] && scanner.atEnd) {
          result[key] = @(v);
        } else {
          [self _exitWithCode:SSH_ERROR
                   andMessage:[NSString
                                  stringWithFormat:@"invalid number \"%@\".",
                                                   value]];
          return result;
        }
      }
    } else if (type == portType) {
      int port = [lv intValue];
      if (port <= 0) {
        port = 22;
      }
      if (port > 65536) {
        [self
            _exitWithCode:SSH_ERROR
               andMessage:[NSString stringWithFormat:@"bad port number \"%@\".",
                                                     key]];
        return result;
      }
      result[key] = @(port);
    } else if (type == intType) {
      int v = 0;
      NSScanner *scanner = [NSScanner scannerWithString:lv];
      if ([scanner scanInt:&v] && scanner.atEnd) {
        result[key] = @(v);
      } else {
        [self
            _exitWithCode:SSH_ERROR
               andMessage:[NSString stringWithFormat:@"invalid number \"%@\".",
                                                     value]];
        return result;
      }
    } else if (type == compressionLevelType) {
      int v = 0;
      NSScanner *scanner = [NSScanner scannerWithString:lv];
      if ([scanner scanInt:&v] && scanner.atEnd && v >= 1 && v <= 9) {
        result[key] = @(v);
      } else {
        [self _exitWithCode:SSH_ERROR
                 andMessage:[NSString stringWithFormat:
                                          @"invalid compression level \"%@\".",
                                          value]];
        return result;
      }
    } else if (type == logLevelType) {
      if ([@[
            SSHOptionValueQUIET,
            SSHOptionValueFATAL,
            SSHOptionValueERROR,
            SSHOptionValueINFO,
            SSHOptionValueVERBOSE,
            SSHOptionValueDEBUG,
            SSHOptionValueDEBUG1,
            SSHOptionValueDEBUG2,
            SSHOptionValueDEBUG3,
          ] indexOfObject:lv] == NSNotFound) {
        [self _exitWithCode:SSH_ERROR
                 andMessage:[NSString
                                stringWithFormat:@"unsupported option \"%@\".",
                                                 key]];
        return result;
      }
      result[key] = lv;
    } else if (type == hostportType) {
      result[key] = value;
    }
  }

  // Apply args:
  NSMutableArray *argsKeys = [args.allKeys mutableCopy];
  NSMutableArray *identityfileInArgs = args[SSHOptionIdentityFile];

  if (identityfileInArgs) {
    [identityfileInArgs addObjectsFromArray:identityfileOption];
  } else if (identityfileOption.count > 0) {
    identityfileInArgs = identityfileInArgs;
  }
  if (identityfileInArgs.count > 0) {
    result[SSHOptionIdentityFile] =
        [NSOrderedSet orderedSetWithArray:identityfileInArgs].array;
    [argsKeys removeObject:SSHOptionIdentityFile];
  }

  if (localforwardOption.count) {
    NSMutableArray<NSString *> *values =
        args[SSHOptionLocalForward] ?: [[NSMutableArray alloc] init];
    [values addObjectsFromArray:localforwardOption];
    result[SSHOptionLocalForward] =
        [NSOrderedSet orderedSetWithArray:values].array;
    [argsKeys removeObject:SSHOptionLocalForward];
  }

  if (remoteforwardOption.count) {
    NSMutableArray<NSString *> *values =
        args[SSHOptionRemoteForward] ?: [[NSMutableArray alloc] init];
    [values addObjectsFromArray:remoteforwardOption];
    result[SSHOptionRemoteForward] =
        [NSOrderedSet orderedSetWithArray:values].array;
    [argsKeys removeObject:SSHOptionRemoteForward];
  }

  if (sendEnvOption.count) {
    NSMutableArray<NSString *> *values =
        args[SSHOptionSendEnv] ?: [[NSMutableArray alloc] init];
    [values addObjectsFromArray:sendEnvOption];
    result[SSHOptionSendEnv] = [NSOrderedSet orderedSetWithArray:values].array;
    [argsKeys removeObject:SSHOptionSendEnv];
  }

  for (NSString *key in argsKeys) {
    result[key] = args[key];
  }

  return result;
}

- (NSObject *)_tryParsePort:(char *)portStr {
  int port = [@(portStr) intValue];

  if (port <= 0 || port > 65536) {
    [self _exitWithCode:SSH_ERROR andMessage:@"Wrong port value provided."];
    return [NSNull null];
  }
  return @(port);
}

- (NSObject *)_parseValues:(char *)value
              withPossible:(NSArray *)possibleValues {
  NSString *val = [@(value) lowercaseString];
  if ([possibleValues indexOfObject:val] == NSNotFound) {
    [self _exitWithCode:SSH_ERROR
             andMessage:[NSString stringWithFormat:@"unsupported option \"%@\"",
                                                   val]];
    return [NSNull null];
  }
  return val;
}

- (int)parseArgs:(int)argc argv:(char **)argv {
  thread_optind = 1;

  NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
  NSMutableArray<NSString *> *options = [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *localforward = [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *remoteforward = [[NSMutableArray alloc] init];
  NSMutableArray<NSString *> *identityfiles = [[NSMutableArray alloc] init];

  int sshLogLevel = 0;
  int clientLogLevel = 0;
  BOOL quiet = NO;

  for (;;) {
    int c = thread_getopt(argc, argv, "AaxR:L:Vo:CGp:i:hqTtvl:F:-W:");
    if (c == -1) {
      break;
    }

    switch (c) {
    case 'a':
      [args setObject:SSHOptionValueNO forKey:SSHOptionForwardAgent];
      break;
    case 'A':
      [args setObject:SSHOptionValueYES forKey:SSHOptionForwardAgent];
      break;
    case 'x':
      [args setObject:SSHOptionValueNO forKey:SSHOptionForwardX11];
      break;
    case 'p':
      [args setObject:[self _tryParsePort:thread_optarg] forKey:SSHOptionPort];
      break;
    case 'C':
      [args setObject:SSHOptionValueYES forKey:SSHOptionCompression];
      break;
    case 'v':
      if (quiet) {
        clientLogLevel++;
      } else {
        sshLogLevel++;
      }
      break;
    case 'q':
      quiet = YES;
      break;
    case 'i':
      [identityfiles addObject:@(thread_optarg)];
      break;
    case 't':
      [args setObject:SSHOptionValueYES forKey:SSHOptionRequestTTY];
      break;
    case 'T':
      [args setObject:SSHOptionValueNO forKey:SSHOptionRequestTTY];
      break;
    case 'l':
      [args setObject:@(thread_optarg) forKey:SSHOptionUser];
      break;
    case 'L':
      [localforward addObject:@(thread_optarg)];
      break;
    case 'R':
      [remoteforward addObject:@(thread_optarg)];
      break;
    case 'F':
      [args setObject:@(thread_optarg) forKey:SSHOptionConfigFile];
      break;
    case 'o':
      // Will apply later
      [options addObject:@(thread_optarg)];
      break;
    case 'G':
      [args setObject:SSHOptionValueYES forKey:SSHOptionPrintConfiguration];
      break;
    case 'V':
      [args setObject:SSHOptionValueYES forKey:SSHOptionPrintVersion];
      break;
    case 'W':
      [args setObject:@(thread_optarg) forKey:SSHOptionSTDIOForwarding];
      break;
    default:
      return [self _exitWithCode:SSH_ERROR andMessage:[self _usage]];
    }
  }

  NSString *logLevelValue = [SSHOptionValueINFO copy];
  if (quiet) {
    if (clientLogLevel > 0) {
      NSArray<const NSString *> *logVals = @[
        SSHOptionValueFATAL, SSHOptionValueERROR, SSHOptionValueINFO,
        SSHOptionValueVERBOSE, SSHOptionValueDEBUG, SSHOptionValueDEBUG2,
        SSHOptionValueDEBUG3
      ];
      logLevelValue = [[logVals
          objectAtIndex:MIN(clientLogLevel - 1, [logVals count])] copy];
    } else {
      logLevelValue = [SSHOptionValueQUIET copy];
    }
  } else if (sshLogLevel > 0) {
    logLevelValue =
        [@[ SSHOptionValueDEBUG, SSHOptionValueDEBUG2, SSHOptionValueDEBUG3 ]
            objectAtIndex:MIN(sshLogLevel - 1, 2)];
  }
  [args setObject:logLevelValue forKey:SSHOptionLogLevel];

  if (identityfiles.count > 0) {
    args[SSHOptionIdentityFile] = identityfiles;
  }

  if (thread_optind < argc) {
    [self _parseUserAtHostStr:@(argv[thread_optind++]) toArgs:args];
  }

  NSMutableArray *cmds = [[NSMutableArray alloc] init];
  while (thread_optind < argc) {
    [cmds addObject:[NSString stringWithUTF8String:argv[thread_optind++]]];
  }

  if (cmds.count > 0) {
    args[SSHOptionRemoteCommand] = [cmds componentsJoinedByString:@" "];
  }

  if (args[SSHOptionHostName] == NULL && args[SSHOptionPrintVersion] == NULL) {
    return [self _exitWithCode:SSH_ERROR andMessage:[self _usage]];
  }

  if (localforward.count > 0) {
    args[SSHOptionLocalForward] = localforward;
  }

  if (remoteforward.count > 0) {
    args[SSHOptionRemoteForward] = remoteforward;
  }

  _options = [self _applyOptions:options toArgs:args];

  return _exitCode;
}

- (int)_logLevelToSSHLogLevel {
  NSString *logLevel = _options[SSHOptionLogLevel];
  if ([@[ SSHOptionValueDEBUG, SSHOptionValueDEBUG1 ] indexOfObject:logLevel] !=
      NSNotFound) {
    return SSH_LOG_WARN;
  }

  if ([SSHOptionValueDEBUG2 isEqual:logLevel]) {
    return SSH_LOG_INFO;
  }
  if ([SSHOptionValueDEBUG3 isEqual:logLevel]) {
    return SSH_LOG_DEBUG;
  }

  if ([SSHOptionValueVERBOSE isEqual:logLevel]) {
    return SSH_LOG_TRACE;
  }

  if ([SSHOptionValueINFO isEqual:logLevel]) {
    return SSH_LOG_NONE;
  }

  if ([SSHOptionValueQUIET isEqual:logLevel]) {
    return SSH_LOG_NONE;
  }

  return SSH_LOG_NONE;
}

- (int)configureSSHSession:(ssh_session)session {
  ssh_set_log_level([self _logLevelToSSHLogLevel]);
  [self _applySSH:session
        optionKey:SSHOptionConnectTimeout
       withOption:SSH_OPTIONS_TIMEOUT];
  [self _applySSH:session
        optionKey:SSHOptionCompression
       withOption:SSH_OPTIONS_COMPRESSION];
  [self _applySSH:session
        optionKey:SSHOptionCompressionLevel
       withOption:SSH_OPTIONS_COMPRESSION_LEVEL];
  [self _applySSH:session
        optionKey:SSHOptionHostName
       withOption:SSH_OPTIONS_HOST];
  [self _applySSH:session optionKey:SSHOptionUser withOption:SSH_OPTIONS_USER];
  [self _applySSH:session optionKey:SSHOptionPort withOption:SSH_OPTIONS_PORT];

  ssh_options_set(session, SSH_OPTIONS_SSH_DIR, BlinkPaths.ssh.UTF8String);

  [self _applySSH:session
        optionKey:SSHOptionProxyCommand
       withOption:SSH_OPTIONS_PROXYCOMMAND];

  NSString *configFile = _options[SSHOptionConfigFile];
  int rc = ssh_options_parse_config(session, configFile.UTF8String);
  if (rc != SSH_OK) {
    return rc;
  }

  char *user = NULL;
  ssh_options_get(session, SSH_OPTIONS_USER, &user);
  if (user) {
    _options[SSHOptionUser] = @(user);
    ssh_string_free_char(user);
  } else {
    NSString *defaultUserName = BKDefaults.defaultUserName;
    if (defaultUserName.length > 0) {
      _options[SSHOptionUser] = defaultUserName;
      [self _applySSH:session
            optionKey:SSHOptionUser
           withOption:SSH_OPTIONS_USER];
    }
  }
  char *identity = NULL;
  ssh_options_get(session, SSH_OPTIONS_IDENTITY, &identity);
  if (identity) {
    NSString *identityStr = @(identity);
    if (![identityStr hasPrefix:@"%d/"]) {
      _options[SSHOptionIdentityFile] = [@[ @(identity) ] mutableCopy];
    }
    ssh_string_free_char(identity);
  }
  char *proxyCmd = NULL;
  ssh_options_get(session, SSH_OPTIONS_PROXYCOMMAND, &proxyCmd);
  if (proxyCmd) {
    _options[SSHOptionProxyCommand] = @(proxyCmd);
    ssh_string_free_char(proxyCmd);
  }

  return rc;
}

- (NSString *)_usage {
  return [@[
    @"usage: ssh [-aCGVqTtvx]",
    @"           [-F configFile] [-i identity_file]",
    @"           [-l login_name] [-o option]",
    @"           [-p port] [-L address] [-R address]",
    @"           [-W host:port]", @"           [user@]hostname [command]", @""
  ] componentsJoinedByString:@"\n"];
}

- (void)_parseUserAtHostStr:(NSString *)str toArgs:(NSMutableDictionary *)args {
  NSArray *userAtHost = [str componentsSeparatedByString:@"@"];
  if ([userAtHost count] < 2) {
    [args setObject:userAtHost[0] forKey:SSHOptionHostName];
  } else {
    [args setObject:userAtHost[0] forKey:SSHOptionUser];
    [args setObject:userAtHost[1] forKey:SSHOptionHostName];
  }

  BKHosts *savedHost = [BKHosts withHost:args[SSHOptionHostName]];
  if (savedHost) {
    if (savedHost.hostName) {
      args[SSHOptionHostName] = savedHost.hostName;
    }
    if (!args[SSHOptionPort] && savedHost.port) {
      args[SSHOptionPort] = savedHost.port;
    }
    if (!args[SSHOptionUser] && savedHost.user && savedHost.user.length > 0) {
      args[SSHOptionUser] = savedHost.user;
    }
    if (!args[SSHOptionIdentityFile] && savedHost.key &&
        ![savedHost.key isEqual:@"None"] /* TODO: Check for None earlier */) {
      args[SSHOptionIdentityFile] = [@[ savedHost.key ] mutableCopy];
    }
    if (savedHost.password.length > 0) {
      args[SSHOptionPassword] = savedHost.password;
    }
    if (savedHost.proxyCmd.length > 0) {
      args[SSHOptionProxyCommand] = savedHost.proxyCmd;
    }
  }
}

- (int)_applySSH:(ssh_session)session
       optionKey:(const NSString *)optionKey
      withOption:(enum ssh_options_e)option {
  id value = _options[optionKey];
  if (!value) {
    return SSH_OK;
  }

  int rc = SSH_ERROR;

  if ([value isKindOfClass:[NSNumber class]]) {
    if (option == SSH_OPTIONS_TIMEOUT) {
      long v = [value intValue];
      rc = ssh_options_set(session, option, &v);
    } else {
      int v = [value intValue];
      rc = ssh_options_set(session, option, &v);
    }
  } else if ([value isKindOfClass:[NSString class]]) {
    const char *v = [value UTF8String];
    rc = ssh_options_set(session, option, v);
  }

  if (rc != SSH_OK) {
    NSLog(@"ERROR in option: %@=%@", optionKey, value);
  }

  return rc;
}

- (NSString *)configurationAsText {
  NSMutableArray<NSString *> *lines =
      [[NSMutableArray alloc] initWithCapacity:_options.count];

  NSArray<NSString *> *sortedKeys =
      [_options.allKeys sortedArrayUsingSelector:@selector(compare:)];
  for (NSString *key in sortedKeys) {
    id val = _options[key];
    if ([val isKindOfClass:[NSArray class]]) {
      NSArray *valArry = (NSArray *)val;
      for (NSObject *v in valArry) {
        [lines addObject:[NSString stringWithFormat:@"%@ %@", key, v]];
      }
    } else {
      if ([SSHOptionPassword isEqual:key]) {
        val = @"********";
      }
      [lines addObject:[NSString stringWithFormat:@"%@ %@", key, val]];
    }
  }
  [lines addObject:@""];

  return [lines componentsJoinedByString:@"\n"];
}

- (id)objectForKeyedSubscript:(const NSString *)key {
  return _options[key];
}

- (void)setObject:(NSString *)obj forKeyedSubscript:(NSString<NSCopying> *)key {
  _options[key] = obj;
}

@end
