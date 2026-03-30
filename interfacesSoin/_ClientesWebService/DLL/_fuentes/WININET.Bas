Attribute VB_Name = "vbWinInet"
Option Explicit

Private Declare Function GetProcessHeap Lib "kernel32" () As Long
Private Declare Function HeapAlloc Lib "kernel32" (ByVal hHeap As Long, ByVal dwFlags As Long, ByVal dwBytes As Long) As Long
Private Declare Function HeapFree Lib "kernel32" (ByVal hHeap As Long, ByVal dwFlags As Long, lpMem As Any) As Long
Private Const HEAP_ZERO_MEMORY = &H8
Private Const HEAP_GENERATE_EXCEPTIONS = &H4

Private Declare Sub CopyMemory1 Lib "kernel32" Alias "RtlMoveMemory" ( _
         hpvDest As Any, ByVal hpvSource As Long, ByVal cbCopy As Long)
Private Declare Sub CopyMemory2 Lib "kernel32" Alias "RtlMoveMemory" ( _
         hpvDest As Long, hpvSource As Any, ByVal cbCopy As Long)

Private Const MAX_PATH = 260
Private Const NO_ERROR = 0
Private Const FILE_ATTRIBUTE_READONLY = &H1
Private Const FILE_ATTRIBUTE_HIDDEN = &H2
Private Const FILE_ATTRIBUTE_SYSTEM = &H4
Private Const FILE_ATTRIBUTE_DIRECTORY = &H10
Private Const FILE_ATTRIBUTE_ARCHIVE = &H20
Private Const FILE_ATTRIBUTE_NORMAL = &H80
Private Const FILE_ATTRIBUTE_TEMPORARY = &H100
Private Const FILE_ATTRIBUTE_COMPRESSED = &H800
Private Const FILE_ATTRIBUTE_OFFLINE = &H1000


Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type

Private Type WIN32_FIND_DATA
        dwFileAttributes As Long
        ftCreationTime As FILETIME
        ftLastAccessTime As FILETIME
        ftLastWriteTime As FILETIME
        nFileSizeHigh As Long
        nFileSizeLow As Long
        dwReserved0 As Long
        dwReserved1 As Long
        cFileName As String * MAX_PATH
        cAlternate As String * 14
End Type


Private Const ERROR_NO_MORE_FILES = 18

Private Declare Function InternetFindNextFile Lib "wininet.dll" Alias "InternetFindNextFileA" _
    (ByVal hFind As Long, lpvFindData As WIN32_FIND_DATA) As Long
    
Private Declare Function FtpFindFirstFile Lib "wininet.dll" Alias "FtpFindFirstFileA" _
    (ByVal hFtpSession As Long, ByVal lpszSearchFile As String, _
      lpFindFileData As WIN32_FIND_DATA, ByVal dwFlags As Long, ByVal dwContent As Long) As Long

Private Declare Function FtpGetFile Lib "wininet.dll" Alias "FtpGetFileA" _
    (ByVal hFtpSession As Long, ByVal lpszRemoteFile As String, _
      ByVal lpszNewFile As String, ByVal fFailIfExists As Boolean, ByVal dwFlagsAndAttributes As Long, _
      ByVal dwFlags As Long, ByVal dwContext As Long) As Boolean

Private Declare Function FtpPutFile Lib "wininet.dll" Alias "FtpPutFileA" _
    (ByVal hFtpSession As Long, ByVal lpszLocalFile As String, _
      ByVal lpszRemoteFile As String, _
      ByVal dwFlags As Long, ByVal dwContext As Long) As Boolean

Private Declare Function FtpSetCurrentDirectory Lib "wininet.dll" Alias "FtpSetCurrentDirectoryA" _
    (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
Private Declare Function FtpGetCurrentDirectory Lib "wininet.dll" Alias "FtpGetCurrentDirectoryA" _
    (ByVal hFtpSession As Long, ByVal lpszDirectory As String, ByRef lpdwCurrentDirectory As Long) As Boolean
' Initializes an application's use of the Win32 Internet functions
Private Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" _
    (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, _
ByVal sProxyBypass As String, ByVal lFlags As Long) As Long

' User agent constant.
Private Const scUserAgent = "SoinInterfaz"

' Use registry access settings.
Private Const INTERNET_OPEN_TYPE_PRECONFIG = 0
Private Const INTERNET_OPEN_TYPE_DIRECT = 1
Private Const INTERNET_OPEN_TYPE_PROXY = 3
Private Const INTERNET_INVALID_PORT_NUMBER = 0

Private Const FTP_TRANSFER_TYPE_ASCII = &H1
Private Const FTP_TRANSFER_TYPE_BINARY = &H2

' Opens a HTTP session for a given site.
Private Declare Function InternetConnect Lib "wininet.dll" Alias "InternetConnectA" _
    (ByVal WinInetHSession As Long, ByVal sServerName As String, ByVal nServerPort As Integer, _
    ByVal sUsername As String, ByVal sPassword As String, ByVal lService As Long, _
    ByVal lFlags As Long, ByVal lContext As Long) As Long
                
Private Declare Function InternetGetLastResponseInfo Lib "wininet.dll" Alias "InternetGetLastResponseInfoA" ( _
    lpdwError As Long, _
    ByVal lpszBuffer As String, _
    lpdwBufferLength As Long) As Boolean

' Number of the TCP/IP port on the server to connect to.
Private Const INTERNET_DEFAULT_FTP_PORT = 21
Private Const INTERNET_DEFAULT_GOPHER_PORT = 70
Private Const INTERNET_DEFAULT_HTTP_PORT = 80
Private Const INTERNET_DEFAULT_HTTPS_PORT = 443
Private Const INTERNET_DEFAULT_SOCKS_PORT = 1080

Private Const INTERNET_OPTION_CONNECT_TIMEOUT = 2
Private Const INTERNET_OPTION_RECEIVE_TIMEOUT = 6
Private Const INTERNET_OPTION_SEND_TIMEOUT = 5

Private Const INTERNET_OPTION_USERNAME = 28
Private Const INTERNET_OPTION_PASSWORD = 29
Private Const INTERNET_OPTION_PROXY_USERNAME = 43
Private Const INTERNET_OPTION_PROXY_PASSWORD = 44

' Type of service to access.
Private Const INTERNET_SERVICE_FTP = 1
Private Const INTERNET_SERVICE_GOPHER = 2
Private Const INTERNET_SERVICE_HTTP = 3

' Opens an HTTP request handle.
Private Declare Function HttpOpenRequest Lib "wininet.dll" Alias "HttpOpenRequestA" _
    (ByVal hHttpSession As Long, ByVal sVerb As String, ByVal sObjectName As String, ByVal sVersion As String, _
    ByVal sReferer As String, ByVal something As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long

Private Const GENERIC_READ = &H80000000
Private Const GENERIC_WRITE = &H40000000

' Sends the specified request to the HTTP server.
Private Declare Function HttpSendRequest Lib "wininet.dll" Alias "HttpSendRequestW" (ByVal _
    hHttpRequest As Long, ByVal sHeaders As String, ByVal lHeadersLength As Long, ByVal sOptional As _
    String, ByVal lOptionalLength As Long) As Integer


' Queries for information about an HTTP request.
Private Declare Function HttpQueryInfo Lib "wininet.dll" Alias "HttpQueryInfoA" _
    (ByVal hHttpRequest As Long, ByVal lInfoLevel As Long, ByRef sBuffer As Any, _
    ByRef lBufferLength As Long, ByRef lIndex As Long) As Integer

' InternetErrorDlg
Private Declare Function InternetErrorDlg Lib "wininet.dll" _
    (ByVal hWnd As Long, ByVal hInternet As Long, ByVal dwError As Long, ByVal dwFlags As Long, ByVal lppvData As Long) As Long

' InternetErrorDlg constants
Private Const FLAGS_ERROR_UI_FILTER_FOR_ERRORS = &H1
Private Const FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS = &H2
Private Const FLAGS_ERROR_UI_FLAGS_GENERATE_DATA = &H4
Private Const FLAGS_ERROR_UI_FLAGS_NO_UI = &H8
Private Const FLAGS_ERROR_UI_SERIALIZE_DIALOGS = &H10

Private Declare Function GetDesktopWindow Lib "user32.dll" () As Long

' The possible values for the lInfoLevel parameter include:
Private Const HTTP_QUERY_CONTENT_TYPE = 1
Private Const HTTP_QUERY_CONTENT_LENGTH = 5
Private Const HTTP_QUERY_EXPIRES = 10
Private Const HTTP_QUERY_LAST_MODIFIED = 11
Private Const HTTP_QUERY_PRAGMA = 17
Private Const HTTP_QUERY_VERSION = 18
Private Const HTTP_QUERY_STATUS_CODE = 19
Private Const HTTP_QUERY_STATUS_TEXT = 20
Private Const HTTP_QUERY_RAW_HEADERS = 21
Private Const HTTP_QUERY_RAW_HEADERS_CRLF = 22
Private Const HTTP_QUERY_FORWARDED = 30
Private Const HTTP_QUERY_SERVER = 37
Private Const HTTP_QUERY_USER_AGENT = 39
Private Const HTTP_QUERY_SET_COOKIE = 43
Private Const HTTP_QUERY_REQUEST_METHOD = 45
Private Const HTTP_STATUS_DENIED = 401
Private Const HTTP_STATUS_PROXY_AUTH_REQ = 407

' Add this flag to the about flags to get request header.
Private Const HTTP_QUERY_FLAG_REQUEST_HEADERS = &H80000000
Private Const HTTP_QUERY_FLAG_NUMBER = &H20000000
' Reads data from a handle opened by the HttpOpenRequest function.
Private Declare Function InternetReadFile Lib "wininet.dll" _
    (ByVal hFile As Long, ByVal sBuffer As String, ByVal lNumBytesToRead As Long, _
    lNumberOfBytesRead As Long) As Integer

Private Type INTERNET_BUFFERS
    dwStructSize As Long        ' used for API versioning. Set to sizeof(INTERNET_BUFFERS)
    Next As Long                ' INTERNET_BUFFERS chain of buffers
    lpcszHeader As Long       ' pointer to headers (may be NULL)
    dwHeadersLength As Long     ' length of headers if not NULL
    dwHeadersTotal As Long      ' size of headers if not enough buffer
    lpvBuffer As Long           ' pointer to data buffer (may be NULL)
    dwBufferLength As Long      ' length of data buffer if not NULL
    dwBufferTotal As Long       ' total size of chunk, or content-length if not chunked
    dwOffsetLow As Long         ' used for read-ranges (only used in HttpSendRequest2)
    dwOffsetHigh As Long
End Type

Private Declare Function HttpSendRequestEx Lib "wininet.dll" Alias "HttpSendRequestExA" _
    (ByVal hHttpRequest As Long, lpBuffersIn As INTERNET_BUFFERS, ByVal lpBuffersOut As Long, _
    ByVal dwFlags As Long, ByVal dwContext As Long) As Long

Private Declare Function HttpEndRequest Lib "wininet.dll" Alias "HttpEndRequestA" _
    (ByVal hHttpRequest As Long, ByVal lpBuffersOut As Long, _
    ByVal dwFlags As Long, ByVal dwContext As Long) As Long


Private Declare Function InternetWriteFile Lib "wininet.dll" _
        (ByVal hFile As Long, ByVal sBuffer As String, _
        ByVal lNumberOfBytesToRead As Long, _
        lNumberOfBytesRead As Long) As Integer

Private Declare Function FtpOpenFile Lib "wininet.dll" Alias _
        "FtpOpenFileA" (ByVal hFtpSession As Long, _
        ByVal sFileName As String, ByVal lAccess As Long, _
        ByVal lFlags As Long, ByVal lContext As Long) As Long
Private Declare Function FtpDeleteFile Lib "wininet.dll" _
    Alias "FtpDeleteFileA" (ByVal hFtpSession As Long, _
    ByVal lpszFileName As String) As Boolean
Private Declare Function InternetSetOption Lib "wininet.dll" Alias "InternetSetOptionA" _
    (ByVal hInternet As Long, ByVal lOption As Long, ByRef sBuffer As Any, ByVal lBufferLength As Long) As Integer
Private Declare Function InternetSetOptionStr Lib "wininet.dll" Alias "InternetSetOptionA" _
    (ByVal hInternet As Long, ByVal lOption As Long, ByVal sBuffer As String, ByVal lBufferLength As Long) As Integer

' Closes a single Internet handle or a subtree of Internet handles.
Private Declare Function InternetCloseHandle Lib "wininet.dll" _
    (ByVal hInet As Long) As Integer

' Queries an Internet option on the specified handle
Private Declare Function InternetQueryOption Lib "wininet.dll" Alias "InternetQueryOptionA" _
    (ByVal hInternet As Long, ByVal lOption As Long, ByRef sBuffer As Any, ByRef lBufferLength As Long) As Integer

' Returns the version number of Wininet.dll.
Private Const INTERNET_OPTION_VERSION = 40

' Contains the version number of the DLL that contains the Windows Internet
' functions (Wininet.dll). This structure is used when passing the
' INTERNET_OPTION_VERSION flag to the InternetQueryOption function.
Private Type tWinInetDLLVersion
    lMajorVersion As Long
    lMinorVersion As Long
End Type

' Adds one or more HTTP request headers to the HTTP request handle.
Private Declare Function HttpAddRequestHeaders Lib "wininet.dll" Alias "HttpAddRequestHeadersA" _
    (ByVal hHttpRequest As Long, ByVal sHeaders As String, ByVal lHeadersLength As Long, _
    ByVal lModifiers As Long) As Integer

' Flags to modify the semantics of this function. Can be a combination of these values:

' Adds the header only if it does not already exist; otherwise, an error is returned.
Private Const HTTP_ADDREQ_FLAG_ADD_IF_NEW = &H10000000

' Adds the header if it does not exist. Used with REPLACE.
Private Const HTTP_ADDREQ_FLAG_ADD = &H20000000

' Replaces or removes a header. If the header value is empty and the header is found,
' it is removed. If not empty, the header value is replaced
Private Const HTTP_ADDREQ_FLAG_REPLACE = &H80000000

' Internet Errors
Private Const INTERNET_ERROR_BASE = 12000

Private Const ERROR_INTERNET_OUT_OF_HANDLES = (INTERNET_ERROR_BASE + 1)
Private Const ERROR_INTERNET_TIMEOUT = (INTERNET_ERROR_BASE + 2)
Private Const ERROR_INTERNET_EXTENDED_ERROR = (INTERNET_ERROR_BASE + 3)
Private Const ERROR_INTERNET_INTERNAL_ERROR = (INTERNET_ERROR_BASE + 4)
Private Const ERROR_INTERNET_INVALID_URL = (INTERNET_ERROR_BASE + 5)
Private Const ERROR_INTERNET_UNRECOGNIZED_SCHEME = (INTERNET_ERROR_BASE + 6)
Private Const ERROR_INTERNET_NAME_NOT_RESOLVED = (INTERNET_ERROR_BASE + 7)
Private Const ERROR_INTERNET_PROTOCOL_NOT_FOUND = (INTERNET_ERROR_BASE + 8)
Private Const ERROR_INTERNET_INVALID_OPTION = (INTERNET_ERROR_BASE + 9)
Private Const ERROR_INTERNET_BAD_OPTION_LENGTH = (INTERNET_ERROR_BASE + 10)
Private Const ERROR_INTERNET_OPTION_NOT_SETTABLE = (INTERNET_ERROR_BASE + 11)
Private Const ERROR_INTERNET_SHUTDOWN = (INTERNET_ERROR_BASE + 12)
Private Const ERROR_INTERNET_INCORRECT_USER_NAME = (INTERNET_ERROR_BASE + 13)
Private Const ERROR_INTERNET_INCORRECT_PASSWORD = (INTERNET_ERROR_BASE + 14)
Private Const ERROR_INTERNET_LOGIN_FAILURE = (INTERNET_ERROR_BASE + 15)
Private Const ERROR_INTERNET_INVALID_OPERATION = (INTERNET_ERROR_BASE + 16)
Private Const ERROR_INTERNET_OPERATION_CANCELLED = (INTERNET_ERROR_BASE + 17)
Private Const ERROR_INTERNET_INCORRECT_HANDLE_TYPE = (INTERNET_ERROR_BASE + 18)
Private Const ERROR_INTERNET_INCORRECT_HANDLE_STATE = (INTERNET_ERROR_BASE + 19)
Private Const ERROR_INTERNET_NOT_PROXY_REQUEST = (INTERNET_ERROR_BASE + 20)
Private Const ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND = (INTERNET_ERROR_BASE + 21)
Private Const ERROR_INTERNET_BAD_REGISTRY_PARAMETER = (INTERNET_ERROR_BASE + 22)
Private Const ERROR_INTERNET_NO_DIRECT_ACCESS = (INTERNET_ERROR_BASE + 23)
Private Const ERROR_INTERNET_NO_CONTEXT = (INTERNET_ERROR_BASE + 24)
Private Const ERROR_INTERNET_NO_CALLBACK = (INTERNET_ERROR_BASE + 25)
Private Const ERROR_INTERNET_REQUEST_PENDING = (INTERNET_ERROR_BASE + 26)
Private Const ERROR_INTERNET_INCORRECT_FORMAT = (INTERNET_ERROR_BASE + 27)
Private Const ERROR_INTERNET_ITEM_NOT_FOUND = (INTERNET_ERROR_BASE + 28)
Private Const ERROR_INTERNET_CANNOT_CONNECT = (INTERNET_ERROR_BASE + 29)
Private Const ERROR_INTERNET_CONNECTION_ABORTED = (INTERNET_ERROR_BASE + 30)
Private Const ERROR_INTERNET_CONNECTION_RESET = (INTERNET_ERROR_BASE + 31)
Private Const ERROR_INTERNET_FORCE_RETRY = (INTERNET_ERROR_BASE + 32)
Private Const ERROR_INTERNET_INVALID_PROXY_REQUEST = (INTERNET_ERROR_BASE + 33)
Private Const ERROR_INTERNET_NEED_UI = (INTERNET_ERROR_BASE + 34)

Private Const ERROR_INTERNET_HANDLE_EXISTS = (INTERNET_ERROR_BASE + 36)
Private Const ERROR_INTERNET_SEC_CERT_DATE_INVALID = (INTERNET_ERROR_BASE + 37)
Private Const ERROR_INTERNET_SEC_CERT_CN_INVALID = (INTERNET_ERROR_BASE + 38)
Private Const ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR = (INTERNET_ERROR_BASE + 39)
Private Const ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR = (INTERNET_ERROR_BASE + 40)
Private Const ERROR_INTERNET_MIXED_SECURITY = (INTERNET_ERROR_BASE + 41)
Private Const ERROR_INTERNET_CHG_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 42)
Private Const ERROR_INTERNET_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 43)
Private Const ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED = (INTERNET_ERROR_BASE + 44)
Private Const ERROR_INTERNET_INVALID_CA = (INTERNET_ERROR_BASE + 45)
Private Const ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP = (INTERNET_ERROR_BASE + 46)
Private Const ERROR_INTERNET_ASYNC_THREAD_FAILED = (INTERNET_ERROR_BASE + 47)
Private Const ERROR_INTERNET_REDIRECT_SCHEME_CHANGE = (INTERNET_ERROR_BASE + 48)
Private Const ERROR_INTERNET_DIALOG_PENDING = (INTERNET_ERROR_BASE + 49)
Private Const ERROR_INTERNET_RETRY_DIALOG = (INTERNET_ERROR_BASE + 50)
Private Const ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR = (INTERNET_ERROR_BASE + 52)
Private Const ERROR_INTERNET_INSERT_CDROM = (INTERNET_ERROR_BASE + 53)

' FTP API errors

Private Const ERROR_FTP_TRANSFER_IN_PROGRESS = (INTERNET_ERROR_BASE + 110)
Private Const ERROR_FTP_DROPPED = (INTERNET_ERROR_BASE + 111)
Private Const ERROR_FTP_NO_PASSIVE_MODE = (INTERNET_ERROR_BASE + 112)

' gopher API errors

Private Const ERROR_GOPHER_PROTOCOL_ERROR = (INTERNET_ERROR_BASE + 130)
Private Const ERROR_GOPHER_NOT_FILE = (INTERNET_ERROR_BASE + 131)
Private Const ERROR_GOPHER_DATA_ERROR = (INTERNET_ERROR_BASE + 132)
Private Const ERROR_GOPHER_END_OF_DATA = (INTERNET_ERROR_BASE + 133)
Private Const ERROR_GOPHER_INVALID_LOCATOR = (INTERNET_ERROR_BASE + 134)
Private Const ERROR_GOPHER_INCORRECT_LOCATOR_TYPE = (INTERNET_ERROR_BASE + 135)
Private Const ERROR_GOPHER_NOT_GOPHER_PLUS = (INTERNET_ERROR_BASE + 136)
Private Const ERROR_GOPHER_ATTRIBUTE_NOT_FOUND = (INTERNET_ERROR_BASE + 137)
Private Const ERROR_GOPHER_UNKNOWN_LOCATOR = (INTERNET_ERROR_BASE + 138)

' HTTP API errors

Private Const ERROR_HTTP_HEADER_NOT_FOUND = (INTERNET_ERROR_BASE + 150)
Private Const ERROR_HTTP_DOWNLEVEL_SERVER = (INTERNET_ERROR_BASE + 151)
Private Const ERROR_HTTP_INVALID_SERVER_RESPONSE = (INTERNET_ERROR_BASE + 152)
Private Const ERROR_HTTP_INVALID_HEADER = (INTERNET_ERROR_BASE + 153)
Private Const ERROR_HTTP_INVALID_QUERY_REQUEST = (INTERNET_ERROR_BASE + 154)
Private Const ERROR_HTTP_HEADER_ALREADY_EXISTS = (INTERNET_ERROR_BASE + 155)
Private Const ERROR_HTTP_REDIRECT_FAILED = (INTERNET_ERROR_BASE + 156)
Private Const ERROR_HTTP_NOT_REDIRECTED = (INTERNET_ERROR_BASE + 160)
Private Const ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION = (INTERNET_ERROR_BASE + 161)
Private Const ERROR_HTTP_COOKIE_DECLINED = (INTERNET_ERROR_BASE + 162)
Private Const ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION = (INTERNET_ERROR_BASE + 168)

' additional Internet API error codes

Private Const ERROR_INTERNET_SECURITY_CHANNEL_ERROR = (INTERNET_ERROR_BASE + 157)
Private Const ERROR_INTERNET_UNABLE_TO_CACHE_FILE = (INTERNET_ERROR_BASE + 158)
Private Const ERROR_INTERNET_TCPIP_NOT_INSTALLED = (INTERNET_ERROR_BASE + 159)
Private Const ERROR_INTERNET_DISCONNECTED = (INTERNET_ERROR_BASE + 163)
Private Const ERROR_INTERNET_SERVER_UNREACHABLE = (INTERNET_ERROR_BASE + 164)
Private Const ERROR_INTERNET_PROXY_SERVER_UNREACHABLE = (INTERNET_ERROR_BASE + 165)

Private Const ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT = (INTERNET_ERROR_BASE + 166)
Private Const ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT = (INTERNET_ERROR_BASE + 167)
Private Const ERROR_INTERNET_SEC_INVALID_CERT = (INTERNET_ERROR_BASE + 169)
Private Const ERROR_INTERNET_SEC_CERT_REVOKED = (INTERNET_ERROR_BASE + 170)

' InternetAutodial specific errors

Private Const ERROR_INTERNET_FAILED_DUETOSECURITYCHECK = (INTERNET_ERROR_BASE + 171)

Private Const INTERNET_ERROR_LAST = ERROR_INTERNET_FAILED_DUETOSECURITYCHECK

'
' flags common to open functions (not InternetOpen()):
'

Private Const INTERNET_FLAG_RELOAD = &H80000000             ' retrieve the original item

'
' flags for InternetOpenUrl():
'

Private Const INTERNET_FLAG_RAW_DATA = &H40000000           ' FTP/gopher find: receive the item as raw (structured) data
Private Const INTERNET_FLAG_EXISTING_CONNECT = &H20000000   ' FTP: use existing InternetConnect handle for server if possible

'
' flags for InternetOpen():
'

Private Const INTERNET_FLAG_ASYNC = &H10000000              ' this request is asynchronous (where supported)

'
' protocol-specific flags:
'

Private Const INTERNET_FLAG_PASSIVE = &H8000000             ' used for FTP connections

'
' additional cache flags
'

Private Const INTERNET_FLAG_NO_CACHE_WRITE = &H4000000      ' don't write this item to the cache
Private Const INTERNET_FLAG_DONT_CACHE = INTERNET_FLAG_NO_CACHE_WRITE
Private Const INTERNET_FLAG_MAKE_PERSISTENT = &H2000000     ' make this item persistent in cache
Private Const INTERNET_FLAG_FROM_CACHE = &H1000000          ' use offline semantics
Private Const INTERNET_FLAG_OFFLINE = INTERNET_FLAG_FROM_CACHE

'
' additional flags
'

Private Const INTERNET_FLAG_SECURE = &H800000               ' use PCT/SSL if applicable (HTTP)
Private Const INTERNET_FLAG_KEEP_CONNECTION = &H400000      ' use keep-alive semantics
Private Const INTERNET_FLAG_NO_AUTO_REDIRECT = &H200000     ' don't handle redirections automatically
Private Const INTERNET_FLAG_READ_PREFETCH = &H100000        ' do background read prefetch
Private Const INTERNET_FLAG_NO_COOKIES = &H80000            ' no automatic cookie handling
Private Const INTERNET_FLAG_NO_AUTH = &H40000               ' no automatic authentication handling
Private Const INTERNET_FLAG_CACHE_IF_NET_FAIL = &H10000     ' return cache file if net request fails

'
' Security Ignore Flags, Allow HttpOpenRequest to overide
'  Secure Channel (SSL/PCT) failures of the following types.
'

Private Const INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP = &H8000       ' ex: https:// to http://
Private Const INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS = &H4000      ' ex: http:// to https://
Private Const INTERNET_FLAG_IGNORE_CERT_DATE_INVALID = &H2000      ' expired X509 Cert.
Private Const INTERNET_FLAG_IGNORE_CERT_CN_INVALID = &H1000        ' bad common name in X509 Cert.

'
' more caching flags
'

Private Const INTERNET_FLAG_RESYNCHRONIZE = &H800           ' asking wininet to update an item if it is newer
Private Const INTERNET_FLAG_HYPERLINK = &H400               ' asking wininet to do hyperlinking semantic which works right for scripts
Private Const INTERNET_FLAG_NO_UI = &H200                   ' no cookie popup
Private Const INTERNET_FLAG_PRAGMA_NOCACHE = &H100          ' asking wininet to add "pragma: no-cache"
Private Const INTERNET_FLAG_CACHE_ASYNC = &H80              ' ok to perform lazy cache-write
Private Const INTERNET_FLAG_FORMS_SUBMIT = &H40             ' this is a forms submit
Private Const INTERNET_FLAG_NEED_FILE = &H10                ' need a file for this request
Private Const INTERNET_FLAG_MUST_CACHE_REQUEST = INTERNET_FLAG_NEED_FILE

'
' flags for FTP
'

Private Const INTERNET_FLAG_TRANSFER_ASCII = FTP_TRANSFER_TYPE_ASCII       ' = &H00000001
Private Const INTERNET_FLAG_TRANSFER_BINARY = FTP_TRANSFER_TYPE_BINARY     ' = &H00000002

'
' flags field masks
'

Private Const SECURITY_INTERNET_MASK = INTERNET_FLAG_IGNORE_CERT_CN_INVALID Or _
                                 INTERNET_FLAG_IGNORE_CERT_DATE_INVALID Or _
                                 INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS Or _
                                 INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP

Private Const INTERNET_FLAGS_MASK = INTERNET_FLAG_RELOAD Or _
                                 INTERNET_FLAG_RAW_DATA Or _
                                 INTERNET_FLAG_EXISTING_CONNECT Or _
                                 INTERNET_FLAG_ASYNC Or _
                                 INTERNET_FLAG_PASSIVE Or _
                                 INTERNET_FLAG_NO_CACHE_WRITE Or _
                                 INTERNET_FLAG_MAKE_PERSISTENT Or _
                                 INTERNET_FLAG_FROM_CACHE Or _
                                 INTERNET_FLAG_SECURE Or _
                                 INTERNET_FLAG_KEEP_CONNECTION Or _
                                 INTERNET_FLAG_NO_AUTO_REDIRECT Or _
                                 INTERNET_FLAG_READ_PREFETCH Or _
                                 INTERNET_FLAG_NO_COOKIES Or _
                                 INTERNET_FLAG_NO_AUTH Or _
                                 INTERNET_FLAG_CACHE_IF_NET_FAIL Or _
                                 SECURITY_INTERNET_MASK Or _
                                 INTERNET_FLAG_RESYNCHRONIZE Or _
                                 INTERNET_FLAG_HYPERLINK Or _
                                 INTERNET_FLAG_NO_UI Or _
                                 INTERNET_FLAG_PRAGMA_NOCACHE Or _
                                 INTERNET_FLAG_CACHE_ASYNC Or _
                                 INTERNET_FLAG_FORMS_SUBMIT Or _
                                 INTERNET_FLAG_NEED_FILE Or _
                                 INTERNET_FLAG_TRANSFER_BINARY Or _
                                 INTERNET_FLAG_TRANSFER_ASCII
                                

Private Const INTERNET_ERROR_MASK_INSERT_CDROM = &H1

Private Const INTERNET_OPTIONS_MASK = (Not INTERNET_FLAGS_MASK)

'
' common per-API flags (new APIs)
'

Private Const WININET_API_FLAG_ASYNC = &H1                  ' force async operation
Private Const WININET_API_FLAG_SYNC = &H4                   ' force sync operation
Private Const WININET_API_FLAG_USE_CONTEXT = &H8            ' use value supplied in dwContext (even if 0)

'
' INTERNET_NO_CALLBACK - if this value is presented as the dwContext parameter
' then no call-backs will be made for that API
'

Private Const INTERNET_NO_CALLBACK = 0

Private Declare Function InternetDial Lib "wininet.dll" _
    (ByVal hWnd As Long, ByVal sConnectoid As String, _
     ByVal dwFlags As Long, lpdwConnection As Long, ByVal dwReserved As Long) As Long

Private Declare Function InternetHangUp Lib "wininet.dll" _
    (ByVal dwConnection As Long, ByVal dwReserved As Long) As Long

Private Declare Function InternetOpenUrl Lib "wininet.dll" Alias "InternetOpenUrlA" _
    (ByVal WinInetHSession As Long, ByVal sUrl As String, _
    ByVal sHeaders As String, ByVal lHeadersLength As Long, _
    ByVal lFlags As Long, ByVal lContext As Long) As Long

Private WinInetHSession As Long
Private WinInetHConnect As Long
Private WinInetHRequest As Long
Private WinInetHeadears As String
Public WinInetCookies   As String

Public Function WinInetConnect(ByVal pAction As String, ByVal pUrl As String, ByVal pData As String) As String
    Dim iRetVal     As Integer
    Dim sBuffer     As String * 65000
    Dim lBufferLen  As Long
    Dim vDllVersion As tWinInetDLLVersion
    Dim sStatus     As String
    Dim lData       As Long
    Dim SecFlag As Long
    Dim dwSecFlag As Long
    
    Dim LvarServer  As String
    Dim LvarPort    As Long
    Dim LvarPage    As String
    Dim LvarPto     As Long
    Dim LvarHttps   As Boolean
    Dim LvarGetPage As String
    Dim LvarData    As String
    
    LvarHttps = False
    LvarPort = INTERNET_DEFAULT_HTTP_PORT
    If LCase(Left(pUrl, 8)) = "https://" Then
        LvarHttps = True
        LvarServer = Mid(pUrl, 9)
        LvarPort = INTERNET_DEFAULT_HTTPS_PORT
    ElseIf LCase(Left(pUrl, 7)) = "http://" Then
        LvarServer = Mid(pUrl, 8)
    ElseIf Left(pUrl, 2) = "//" Then
        LvarServer = Mid(pUrl, 3)
    Else
        LvarServer = pUrl
    End If
    
    If pAction <> "GET" And pAction <> "POST" Then
        Err.Raise 10000, , "La action solo puede ser GET o POST"
    End If
    
    LvarPto = InStr(LvarServer, "/")
    If LvarPto = 0 Then
        Err.Raise 10000, , "Url debe ser de la forma: [http[s]:][//]servidor[:puerto]/pagina"
    End If
         
    LvarPage = Mid(LvarServer, LvarPto)
    LvarServer = Left(LvarServer, LvarPto - 1)
    
    LvarPto = InStr(LvarServer, ":")
    If LvarPto > 0 Then
        LvarPort = Val(Mid(LvarServer, LvarPto + 1))
        LvarServer = Left(LvarServer, LvarPto - 1)
    End If
    
    If Not CBool(WinInetHSession) Then
        WinInetHSession = InternetOpen(scUserAgent, INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
        If Not CBool(WinInetHSession) Then
            Err.Raise 10000, , "InternetOpen failed."
        End If
    End If
    
    If LvarHttps = 1 Then
        SecFlag = INTERNET_FLAG_SECURE Or _
                  INTERNET_FLAG_IGNORE_CERT_CN_INVALID Or _
                  INTERNET_FLAG_IGNORE_CERT_DATE_INVALID
    Else
        SecFlag = 0
    End If
    WinInetHConnect = InternetConnect(WinInetHSession, LvarServer, LvarPort, _
                            vbNullString, vbNullString, INTERNET_SERVICE_HTTP, 0, 0)

    If WinInetHConnect = 0 Then
        Err.Raise 10000, , "InternetConnect call failed; Error code: " & Err.LastDllError & "."
    End If
        
    If pAction = "GET" And Len(pData) < 200 Then
        If pData <> "" Then
            LvarPage = LvarPage + "?" + pData
        Else
            LvarPage = LvarPage
        End If
        
        LvarData = vbNullString
        lData = 0
        
        WinInetHRequest = HttpOpenRequest(WinInetHConnect, "GET", LvarPage, "HTTP/1.0", vbNullString, 0, _
            INTERNET_FLAG_RELOAD Or INTERNET_FLAG_KEEP_CONNECTION Or SecFlag, 0)
    Else
        LvarData = pData
        'LvarData = "AU=hola"
        lData = Len(LvarData)
        
        WinInetHRequest = HttpOpenRequest(WinInetHConnect, "POST", LvarPage, "HTTP/1.0", vbNullString, 0, _
            INTERNET_FLAG_RELOAD Or SecFlag, 0)
    End If
       
    If WinInetHRequest = 0 Then
        ' HttpOpenRequest failed
        Err.Raise 10000, , "HttpOpenRequest call failed; Error code: " & Err.LastDllError & "."
    End If
            
    Dim sHeader As String
    
    Dim LvarHeaders As String
    LvarHeaders = ""
    LvarHeaders = LvarHeaders & "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/x-shockwave-flash, */*" & vbCrLf
    LvarHeaders = LvarHeaders & "Accept-Language: en-us" & vbCrLf
    LvarHeaders = LvarHeaders & "UA-CPU: x86" & vbCrLf
    LvarHeaders = LvarHeaders & "accept-Charset: utf-8" & vbCrLf
    LvarHeaders = LvarHeaders & "Content-Type: application/x-www-form-URLencoded" & vbCrLf
    LvarHeaders = LvarHeaders & "Accept-Encoding: gzip, deflate" & vbCrLf
    LvarHeaders = LvarHeaders & "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322)" & vbCrLf
    LvarHeaders = LvarHeaders & "Host: " & LvarServer & ":" & LvarPort & vbCrLf
    LvarHeaders = LvarHeaders & "Connection: Keep-Alive" & vbCrLf
    If WinInetCookies <> "" Then
        LvarHeaders = LvarHeaders & WinInetCookies
    End If
    iRetVal = HttpAddRequestHeaders(WinInetHRequest, LvarHeaders, Len(LvarHeaders), HTTP_ADDREQ_FLAG_REPLACE Or HTTP_ADDREQ_FLAG_ADD)
    
    Dim dwTimeOut As Long
    dwTimeOut = 60000 ' time out is set to 1 minute
    iRetVal = InternetSetOption(WinInetHRequest, INTERNET_OPTION_CONNECT_TIMEOUT, _
        dwTimeOut, 4)
    iRetVal = InternetSetOption(WinInetHRequest, INTERNET_OPTION_RECEIVE_TIMEOUT, _
        dwTimeOut, 4)
    iRetVal = InternetSetOption(WinInetHRequest, INTERNET_OPTION_SEND_TIMEOUT, _
        dwTimeOut, 4)
    
Resend:
    iRetVal = HttpSendRequest(WinInetHRequest, vbNullString, 0, LvarData, lData)
    If (iRetVal <> 1) And (Err.LastDllError = 12045) Then
        'Certificate Authority is invalid.
        Err.Raise 10000, , "HttpSendRequest with Invalid Cert Auth; Error code: " & Err.LastDllError & "."
    End If
    
    If iRetVal = 0 Then
        ' HttpSendRequest failed
        Err.Raise 10000, , "HttpSendRequest call failed; Error code: " & Err.LastDllError & "."
    End If
    
    Dim dwStatus As Long, dwStatusSize As Long
    dwStatusSize = Len(dwStatus)
    HttpQueryInfo WinInetHRequest, HTTP_QUERY_FLAG_NUMBER Or HTTP_QUERY_STATUS_CODE, dwStatus, dwStatusSize, 0
    Select Case dwStatus
        Case HTTP_STATUS_PROXY_AUTH_REQ
            ' Proxy Authentication
            Err.Raise 10000, , "HttpSendRequest Proxy Authentication failed."
            iRetVal = InternetSetOptionStr(WinInetHRequest, INTERNET_OPTION_PROXY_USERNAME, _
                "IUSR_WEIHUA1", Len("IUSR_WEIHUA1") + 1)
            iRetVal = InternetSetOptionStr(WinInetHRequest, INTERNET_OPTION_PROXY_PASSWORD, _
                "IUSR_WEIHUA1", Len("IUSR_WEIHUA1") + 1)
            GoTo Resend
        Case HTTP_STATUS_DENIED
            ' Http Authentication
            Err.Raise 10000, , "HttpSendRequest Http Authentication failed."
            iRetVal = InternetSetOptionStr(WinInetHRequest, INTERNET_OPTION_USERNAME, _
                "IUSR_WEIHUA1", Len("IUSR_WEIHUA1") + 1)
            iRetVal = InternetSetOptionStr(WinInetHRequest, INTERNET_OPTION_PASSWORD, _
                "IUSR_WEIHUA1", Len("IUSR_WEIHUA1") + 1)
            GoTo Resend
    End Select

    WinInetHeadears = GetQueryInfo(HTTP_QUERY_RAW_HEADERS_CRLF)

    Dim LvarHtml            As String
    Dim sReadBuffer         As String * 2048
    Dim lNumberOfBytesRead  As Long
    
    LvarHtml = ""
    Do
        sReadBuffer = vbNullString
        iRetVal = InternetReadFile(WinInetHRequest, sReadBuffer, Len(sReadBuffer), lNumberOfBytesRead)
        LvarHtml = LvarHtml & Left$(sReadBuffer, lNumberOfBytesRead)
    Loop While CBool(lNumberOfBytesRead)
    
    LvarHtml = UTF8Decoder(LvarHtml)

    WinInetConnect = LvarHtml
End Function

'http://msdn.microsoft.com/library/default.asp?url=/archive/en-us/dnarwebtool/html/msdn_vbhttp.asp

Private Function GetQueryInfo(ByVal iInfoLevel As Long) As String
    Dim sBuffer         As String * 1024
    Dim lBufferLength   As Long
    
    lBufferLength = Len(sBuffer)
    HttpQueryInfo WinInetHRequest, iInfoLevel, ByVal sBuffer, lBufferLength, 0
    GetQueryInfo = CStr(sBuffer)
'    GetQueryInfo WinInetHRequest, lblContentType, HTTP_QUERY_CONTENT_TYPE
'    GetQueryInfo WinInetHRequest, lblContentLength, HTTP_QUERY_CONTENT_LENGTH
'    GetQueryInfo WinInetHRequest, lblLastModified, HTTP_QUERY_LAST_MODIFIED
'    GetQueryInfo WinInetHRequest, lblVersion, HTTP_QUERY_VERSION
'    GetQueryInfo WinInetHRequest, lblStatusCode, HTTP_QUERY_STATUS_CODE
'    GetQueryInfo WinInetHRequest, lblStatusText, HTTP_QUERY_STATUS_TEXT
'    GetQueryInfo WinInetHRequest, lblRawHeaders, HTTP_QUERY_RAW_HEADERS
'    GetQueryInfo WinInetHRequest, txtRequestHeaders, HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_RAW_HEADERS_CRLF)
'    GetQueryInfo WinInetHRequest, txtResponseHeaders, HTTP_QUERY_RAW_HEADERS_CRLF
'    GetQueryInfo WinInetHRequest, lblForwarded, HTTP_QUERY_FORWARDED
'    GetQueryInfo WinInetHRequest, lblServer, HTTP_QUERY_SERVER
'    GetQueryInfo WinInetHRequest, lblRequestMethod, HTTP_QUERY_REQUEST_METHOD
'    GetQueryInfo WinInetHRequest, lblPragma, HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_PRAGMA
'    GetQueryInfo WinInetHRequest, lblUserAgent, HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_USER_AGENT
'    GetQueryInfo WinInetHRequest, lblRequestMethod2, HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_REQUEST_METHOD
End Function

Public Function WinInetGetHeader(pHeader As String) As String
    Dim LvarHeader As String
    Dim LvarPto    As Long
    
    LvarPto = InStr(vbCrLf & WinInetHeadears, vbCrLf & pHeader & ":")
    If LvarPto > 0 Then
        LvarHeader = Mid(WinInetHeadears, InStr(LvarPto, WinInetHeadears, ":") + 1)
        LvarPto = InStr(LvarHeader & vbCrLf, vbCrLf) - 1
        LvarHeader = Left(LvarHeader, LvarPto)
    Else
        LvarHeader = ""
    End If
    WinInetGetHeader = Trim(LvarHeader)
End Function
Public Sub WinInetClose()
    Dim iRetVal     As Integer

    iRetVal = InternetCloseHandle(WinInetHRequest)
    iRetVal = InternetCloseHandle(WinInetHConnect)
    iRetVal = InternetCloseHandle(WinInetHSession)
    WinInetHSession = 0
End Sub
