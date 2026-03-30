<%
	/* opensmpp test server
	ipAddress = "10.7.7.30";
	port      = 12345;
	systemId  = "pavel";
	password  = "dfsew";
	sourceAddressRange = "8181*"; */
	
	/* coldfusion 7 blackstone test server
	ipAddress = "10.7.7.30";
	port      = 7901;
	systemId  = "cf";
	password  = "cf";
	sourceAddressRange = "8181*"; */

	/* servidor del piloto del ICE/8181 */
	ipAddress = "200.91.85.214";
	port = 17901;
	systemId = "soin";
	password = "soin2311";
	sourceAddressRange = "8181*";
	
%><%!
	/*
		Parametrizacion de la pantalla:
	*/
	
	/**
	 * Address of the SMSC.
	 */
	String ipAddress = null;
	int port = 0;
	/**
	 * The name & password which identifies you to SMSC.
	 */
	String systemId = null;
	String password = null;

	/*
	 * for information about these variables have a look in SMPP 3.4
	 * specification
	 */
	String systemType = "";
	String serviceType = "";
	byte sourceTon = 2, sourceNpi = 1;
	byte tdmaTon = 2, tdmaNpi = 1;
	byte gsmTon  = 1, gsmNpi  = 1;
	byte destTon = 0, destNpi = 0;
	String tdmaPrefix = "712", gsmPrefix  = "506";
	
	String sourceNumber = "8181";
	String sourceAddressRange = null;
	
	String destNumber = null;
	String fromUser = null;
	String shortMessage = null;
	String messageSuffix = " soin.net(c)2005";

	/**
	 * If you attemt to receive message, how long will the application
	 * wait for data.
	 */
	//long receiveTimeout = Data.RECEIVE_BLOCKING;
	long receiveTimeout = 30000; // millis
	/*

		TON                 Value
		Unknown             00000000
		International       00000001
		National            00000010
		Network Specific    00000011
		Subscriber Number   00000100
		Alphanumeric        00000101
		Abbreviated         00000110
		
		NPI                 Value
		Unknown                00000000
		ISDN (E163/E164)       00000001
		Data (X.121)           00000011
		Telex (F.69)           00000100
		Land Mobile (E.212)    00000110
		National               00001000
		Private                00001001
		ERMES                  00001010
		Internet (IP)          00001110
		WAP Client Id (to be   00010010
		defined by WAP Forum)  
	*/
	

%>