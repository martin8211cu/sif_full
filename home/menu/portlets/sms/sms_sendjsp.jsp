<%
	/* opensmpp test server
	ipAddress = "10.7.7.30";
	port      = 12345;
	systemId  = "pavel";
	password  = "dfsew"; */
	
	/* coldfusion 7 blackstone test server */
	ipAddress = "10.7.7.30";
	port      = 7901;
	systemId  = "cf";
	password  = "cf";

	/* servidor del piloto del ICE/8181
	ipAddress = "200.91.85.214";
	port = 17901;
	systemId = "soin";
	password = "soin2311"; */
	
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
	
	String destNumber = null;
	String fromUser = null;
	String shortMessage = null;
	String messageSuffix = " soin.net(c)2005";
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
	

%><%@ page import="
 java.io.*,

 org.smpp.*,
 org.smpp.TCPIPConnection,
 org.smpp.pdu.*,
 org.smpp.debug.Debug,
 org.smpp.debug.Event,
 org.smpp.debug.FileDebug,
 org.smpp.debug.FileEvent,
 org.smpp.util.Queue"
%><%!
/**
 * Some code is based on SMPPTest.java from the SMPP toolkit from OpenSMPP 2.0
 * @see http://sourceforge.net/projects/smstools/
 */

	/**
	 * This is the SMPP session used for communication with SMSC.
	 */
	static Session session = null;

	/**
	 * How you want to bind to the SMSC: transmitter (t), receiver (r) or
	 * transciever (tr). Transciever can both send messages and receive
	 * messages. Note, that if you bind as receiver you can still receive
	 * responses to you requests (submissions).
	 */
	String bindOption = "t";

	/**
	 * The range of addresses the smpp session will serve.
	 */
	AddressRange addressRange = new AddressRange();

	
	Address sourceAddress = null;
	Address destAddress = null;
	String scheduleDeliveryTime = "";
	String validityPeriod = "";
	String messageId = "";
	byte esmClass = 0;
	byte protocolId = 0;
	byte priorityFlag = 0;
	byte registeredDelivery = 0;
	byte replaceIfPresentFlag = 0;
	byte dataCoding = 0;
	byte smDefaultMsgId = 0;

	/**
	 * If you attemt to receive message, how long will the application
	 * wait for data.
	 */
	long receiveTimeout = Data.RECEIVE_BLOCKING;
	
	private boolean bind(JspWriter out) throws Exception {

			BindRequest request = null;
			BindResponse response = null;
			request = new BindTransmitter();

			TCPIPConnection connection = new TCPIPConnection(ipAddress, port);
			connection.setReceiveTimeout(20 * 1000);
			session = new Session(connection);

			// set values
			request.setSystemId(systemId);
			request.setPassword(password);
			request.setSystemType(systemType);
			request.setInterfaceVersion((byte) 0x34);
			request.setAddressRange(addressRange);

			// send the request
			//out.println("Bind request " + request.debugString());
			response = session.bind(request);
			//out.println("Bind response " + response.debugString());
			if (response.getCommandStatus() == Data.ESME_ROK) {
				return true;
			}
			return false;
	}

	private void unbind(JspWriter out)  throws Exception {

			// send the request
			//out.println("Going to unbind.");
			//if (session.getReceiver().isReceiver()) {
				//out.println("It can take a while to stop the receiver.");
			//}
			UnbindResp response = session.unbind();
			//out.println("Unbind response " + response.debugString());
	}

	/**
	 * Creates a new instance of <code>SubmitSM</code> class, lets you set
	 * subset of fields of it. This PDU is used to send SMS message
	 * to a device.
	 *
	 * See "SMPP Protocol Specification 3.4, 4.4 SUBMIT_SM Operation."
	 * @see Session#submit(SubmitSM)
	 * @see SubmitSM
	 * @see SubmitSMResp
	 */
	private void submit(JspWriter out)  throws Exception {

			SubmitSM request = new SubmitSM();
			SubmitSMResp response;

			// set values
			request.setServiceType(serviceType);
			request.setSourceAddr(sourceAddress);
			request.setDestAddr(destAddress);
			request.setReplaceIfPresentFlag(replaceIfPresentFlag);
			request.setShortMessage(shortMessage);
			request.setScheduleDeliveryTime(scheduleDeliveryTime);
			request.setValidityPeriod(validityPeriod);
			request.setEsmClass(esmClass);
			request.setProtocolId(protocolId);
			request.setPriorityFlag(priorityFlag);
			request.setRegisteredDelivery(registeredDelivery);
			request.setDataCoding(dataCoding);
			request.setSmDefaultMsgId(smDefaultMsgId);

			// send the request

			request.assignSequenceNumber(true);
			//out.println("Submit request " + request.debugString());
			response = session.submit(request);
			//out.println("Submit response " + response.debugString());
			messageId = response.getMessageId();
	}

%><%
	try {
		destNumber = request.getParameter("tel");
		shortMessage = request.getParameter("msg");
		fromUser = request.getParameter("from");
		String activate = request.getParameter("activate");
		if (activate == null || !activate.equals("activate")) {
			throw new Exception("No requests outside of locally managed network. Sorry. [SQN-05487]");
		}
		if (shortMessage == null) {
			shortMessage = "saludos";
		}
		if (destNumber == null || destNumber.length() == 0) {
			destNumber = "";
			throw new Exception("Especifique el telefono destino");
		}
		if (destNumber.startsWith("8")) {
			// En Costa Rica los celulares GSM son 8xx-xxxx
			destNumber = gsmPrefix + destNumber;
			destTon    = gsmTon;
			destNpi    = gsmNpi;
		} else {
			// En Costa Rica los celulares TDMA son 3xx-xxxx
			destNumber = tdmaPrefix + destNumber;
			destTon    = tdmaTon;
			destNpi    = tdmaNpi;
		}
		if (fromUser == null || fromUser.length() == 0) {
			throw new Exception("Necesita especificar el usuario para enviar mensajes");
		}
		
		// validar: El mensaje debe medir a lo sumo 160 caracteres, y no debe tener tildes ni caracteres > 128
		int maxLen = 160 - fromUser.length() - ": ".length() - messageSuffix.length();
		if (shortMessage.length() > maxLen) {
			shortMessage = shortMessage.substring(0, maxLen);
		}
		shortMessage = fromUser + ": " + shortMessage + messageSuffix;
		// asegurarse de que no haya caracteres raros
		StringBuffer sb = new StringBuffer(165);
		for (int smpos = 0; smpos < shortMessage.length(); smpos++) {
			char ch = shortMessage.charAt(smpos) ;
			if (ch >= 32 && ch <= 126)
				sb.append(ch);
		}
		shortMessage = sb.toString();
		
		//out.println("iniciando");
		sourceAddress = new Address(sourceTon,sourceNpi,sourceNumber);
		destAddress = new Address(destTon,destNpi,destNumber);
		if (!bind(out)) {
			throw new Exception("No hay conexion con el centro de mensajes");
		}
		submit(out);
		unbind(out);
		out.println("ok,dest_ton,dest_npi,dest_num,src_ton,src_npi,src_num,msg_id");
		out.print("1,");
		out.print(destTon);        out.print (',');
		out.print(destNpi);        out.print (',');
		out.print(destNumber);     out.print (',');
		out.print(sourceTon);      out.print (',');
		out.print(sourceNpi);      out.print (',');
		out.print(sourceNumber);   out.print (',');
		out.print(messageId);      out.print (',');
		out.println();
	} catch (Throwable e) {
		out.println("ok,errormsg");
		out.print("0,");
		out.println(e.getMessage());
	}
%>
