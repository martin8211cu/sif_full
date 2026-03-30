<xmp><%@ page import="
 java.io.*,
 java.util.Properties,

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
 * Class <code>SMPPTest</code> shows how to use the SMPP toolkit.
 * You can bound and unbind from the SMSC, you can send every possible 
 * pdu and wait for a pdu sent from the SMSC.
 *
 * @author Logica Mobile Networks SMPP Open Source Team
 * @version $Revision: 1.1 $
 */
	static final String copyright =
		"Copyright (c) 1996-2001 Logica Mobile Networks Limited\n"
			+ "This product includes software developed by Logica by whom copyright\n"
			+ "and know-how are retained, all rights reserved.\n";
	static final String version = "SMPP Open Source test & demonstration application, version 1.1\n";
%><%= copyright %>
<%= version %>
<%!
	/**
	 * File with default settings for the application.
	 */
	static String propsFilePath = "./etc/smpptest.cfg";

	/**
	 * This is the SMPP session used for communication with SMSC.
	 */
	static Session session = null;

	/**
	 * Contains the parameters and default values for this test
	 * application such as system id, password, default npi and ton
	 * of sender etc.
	 */
	Properties properties = new Properties();

	/**
	 * If the application is bound to the SMSC.
	 */
	boolean bound = false;

	/**
	 * If the application has to keep reading commands
	 * from the keyboard and to do what's requested.
	 */
	private boolean keepRunning = true;

	/**
	 * Address of the SMSC.
	 */
	String ipAddress = "10.7.7.30";

	/**
	 * The port number to bind to on the SMSC server.
	 */
	int port = 12345;

	/**
	 * The name which identifies you to SMSC.
	 */
	String systemId = "pavel";

	/**
	 * The password for authentication to SMSC.
	 */
	String password = "dfsew";

	/**
	 * How you want to bind to the SMSC: transmitter (t), receiver (r) or
	 * transciever (tr). Transciever can both send messages and receive
	 * messages. Note, that if you bind as receiver you can still receive
	 * responses to you requests (submissions).
	 */
	String bindOption = "t";

	/**
	 * Indicates that the Session has to be asynchronous.
	 * Asynchronous Session means that when submitting a Request to the SMSC
	 * the Session does not wait for a response. Instead the Session is provided
	 * with an instance of implementation of ServerPDUListener from the smpp
	 * library which receives all PDUs received from the SMSC. It's
	 * application responsibility to match the received Response with sended Requests.
	 */
	boolean asynchronous = false;

	/**
	 * The range of addresses the smpp session will serve.
	 */
	AddressRange addressRange = new AddressRange();

	/*
	 * for information about these variables have a look in SMPP 3.4
	 * specification
	 */
	String systemType = "";
	String serviceType = "";
	byte addressTon = 1, addressNpi = 1;
	
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
	
	
	Address sourceAddress = null;
	Address destAddress = null;
	String scheduleDeliveryTime = "";
	String validityPeriod = "";
	String shortMessage = "Un mensaje de prueba";
	int numberOfDestination = 1;
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
	
	/**
	 * The first method called to start communication
	 * betwen an ESME and a SMSC. A new instance of <code>TCPIPConnection</code>
	 * is created and the IP address and port obtained from user are passed
	 * to this instance. New <code>Session</code> is created which uses the created
	 * <code>TCPIPConnection</code>.
	 * All the parameters required for a bind are set to the <code>BindRequest</code>
	 * and this request is passed to the <code>Session</code>'s <code>bind</code>
	 * method. If the call is successful, the application should be bound to the SMSC.
	 *
	 * See "SMPP Protocol Specification 3.4, 4.1 BIND Operation."
	 * @see BindRequest
	 * @see BindResponse
	 * @see TCPIPConnection
	 * @see Session#bind(BindRequest)
	 * @see Session#bind(BindRequest,ServerPDUEventListener)
	 */
	private void bind(JspWriter out) throws Exception {

			if (bound) {
				out.println("Already bound, unbind first.");
				return;
			}

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
			out.println("Bind request " + request.debugString());
			response = session.bind(request);
			out.println("Bind response " + response.debugString());
			if (response.getCommandStatus() == Data.ESME_ROK) {
				bound = true;
			}
	}

	/**
	 * Ubinds (logs out) from the SMSC and closes the connection.
	 *
	 * See "SMPP Protocol Specification 3.4, 4.2 UNBIND Operation."
	 * @see Session#unbind()
	 * @see Unbind
	 * @see UnbindResp
	 */
	private void unbind(JspWriter out)  throws Exception {

			if (!bound) {
				out.println("Not bound, cannot unbind.");
				return;
			}

			// send the request
			out.println("Going to unbind.");
			if (session.getReceiver().isReceiver()) {
				out.println("It can take a while to stop the receiver.");
			}
			UnbindResp response = session.unbind();
			out.println("Unbind response " + response.debugString());
			bound = false;

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

			int count = 1;
			out.println();
			for (int i = 0; i < count; i++) {
				request.assignSequenceNumber(true);
				out.print("#" + i + "  ");
				out.println("Submit request " + request.debugString());
				if (asynchronous) {
					session.submit(request);
					out.println();
				} else {
					response = session.submit(request);
					out.println("Submit response " + response.debugString());
					messageId = response.getMessageId();
				}
			}
	}

%><%
	try {
		out.println("iniciando");
		sourceAddress = new Address(addressTon,addressNpi,"8381218");
		destAddress = new Address(addressTon,addressNpi,"8381218");
		out.println("bind...");
		bind(out);
		out.println("submit...");
		submit(out);
		out.println("unbind...");
		unbind(out);
		out.println("fin...");
	} catch (Throwable e) {
		out.println();
		e.printStackTrace(new PrintWriter(out));
	}
%>
</xmp>