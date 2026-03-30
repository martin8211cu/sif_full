<%!
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
	
	private boolean bind(BindRequest request, JspWriter out) throws Exception {

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


	/**
	 * Receives one PDU of any type from SMSC and prints it on the screen.
	 * @see Session#receive()
	 * @see Response
	 * @see ServerPDUEvent
	 */
	private PDU receive(JspWriter out) throws Exception {
		out.print("SMPPTest.receive()");
		PDU pdu = null;
		out.print("Going to receive a PDU. ");
		if (receiveTimeout == Data.RECEIVE_BLOCKING) {
			out.print(
				"The receive is blocking, i.e. the application " + "will stop until a PDU will be received.");
		} else {
			out.print("The receive timeout is " + receiveTimeout / 1000 + " sec.");
		}
		out.println();
		pdu = session.receive(receiveTimeout);
		if (pdu != null) {
			out.println("Received PDU " + pdu.debugString());
			if (pdu.isRequest()) {
				Response response = ((Request) pdu).getResponse();
				// respond with default response
				out.println("Going to send default response to request " + response.debugString());
				session.respond(response);
			}
		} else {
			out.println("No PDU received this time.");
		}
		return (pdu);
	}


%>