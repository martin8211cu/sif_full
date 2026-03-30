<%@ page import="
 java.io.*,

 org.smpp.*,
 org.smpp.TCPIPConnection,
 org.smpp.pdu.*,
 org.smpp.debug.Debug,
 org.smpp.debug.Event,
 org.smpp.debug.FileDebug,
 org.smpp.debug.FileEvent,
 org.smpp.util.Queue"
%><%@ include file="sms-util.jsp" %><%@ include file="sms-config.jsp" %><%
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
		if (!bind(new BindTransmitter(), out)) {
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
