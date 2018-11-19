#ifdef TAP_LITTLE_ENDIAN
#define ntohs(x) RtlUshortByteSwap(x)
#define htons(x) RtlUshortByteSwap(x)
#define ntohl(x) RtlUlongByteSwap(x)
#define htonl(x) RtlUlongByteSwap(x)
#else
#define ntohs(x) ((USHORT)(x))
#define htons(x) ((USHORT)(x))
#define ntohl(x) ((ULONG)(x))
#define htonl(x) ((ULONG)(x))
#endif