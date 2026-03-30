
<cfset Lvar_FAX01ENUMDOC = "7000">

<cfloop index="jj" from="1" to="5">
	<cfset Lvar_FAX01ENUMDOC = Lvar_FAX01ENUMDOC - 1>
	<cfdump var="-P50002#Lvar_FAX01ENUMDOC#,">


  <cfset LvarXML_IE = "<?xml version='1.0' encoding='UTF-8'?> <TRANSACCION><FAXC003><RERDES>695 Liquidaci?n Ruta: R01</RERDES><RERUSR>LNSI_EXIGO</RERUSR><RERFEC>2011-01-01 09:00:11</RERFEC><FAM33COD>CLO</FAM33COD><C09COD>R01</C09COD><USRPAGADO>LNSI_EXIGO</USRPAGADO><FAXC005><RENREC>RHR0100012</RENREC><RENMON>282.37</RENMON><RENFEC>2011-07-21 02:38:57</RENFEC><C06COD>20708</C06COD><CLICOD>VFTY</CLICOD><MONCOD>CO</MONCOD><MONTPC>1</MONTPC><FAXC006><FACTTR>FC</FACTTR><FACDOC>VFH3824850</FACDOC><RENREC>RHR0100012</RENREC><REDMON>1343.00</REDMON><CLICOD>VFTY</CLICOD><MONCOD>CO</MONCOD></FAXC006><FAXC006><FACTTR>FC</FACTTR><FACDOC>VFH3824852</FACDOC><RENREC>RHR0100012</RENREC><REDMON>-1060.63</REDMON><CLICOD>VFTY</CLICOD><MONCOD>CO</MONCOD></FAXC006></FAXC005><FAXC007><num_factura>VFH3824855</num_factura><cod_puve>VHME</cod_puve><fec_emision>2010-08-21 02:52:47</fec_emision><mon_saldo>0</mon_saldo><num_liquidacion>695</num_liquidacion><mon_original>0</mon_original><FAXC008><num_factura>VFH3824855</num_factura><num_linea>1</num_linea><cod_producto>AD</cod_producto><fec_despacho>02/01/2010 00:00:00</fec_despacho><num_edicion>6207</num_edicion><cantidad_cred>9</cantidad_cred><monto_descuento>0</monto_descuento><monto_impuesto>0</monto_impuesto><monto_linea>0</monto_linea><CTAP01>  72</CTAP01><CTAP02>   2</CTAP02><CTAP03>  02</CTAP03><CTAP04>  03</CTAP04><CTAP05>072</CTAP05><CTAP06>91</CTAP06><CTAD01></CTAD01><CTAD02></CTAD02><CTAD03></CTAD03><CTAD04></CTAD04><CTAD05></CTAD05><CTAD06></CTAD06><CTAI01></CTAI01><CTAI02></CTAI02><CTAI03></CTAI03><CTAI04></CTAI04><CTAI05></CTAI05><CTAI06></CTAI06></FAXC008><FAXC008><num_factura>VFH3824855</num_factura><num_linea>2</num_linea><cod_producto>AD</cod_producto><fec_despacho>03/01/2010 00:00:00</fec_despacho><num_edicion>6208</num_edicion><cantidad_cred>9</cantidad_cred><monto_descuento>0</monto_descuento><monto_impuesto>0</monto_impuesto><monto_linea>0</monto_linea><CTAP01>  72</CTAP01><CTAP02>   2</CTAP02><CTAP03>  02</CTAP03><CTAP04>  03</CTAP04><CTAP05>072</CTAP05><CTAP06>91</CTAP06><CTAD01></CTAD01><CTAD02></CTAD02><CTAD03></CTAD03><CTAD04></CTAD04><CTAD05></CTAD05><CTAD06></CTAD06><CTAI01></CTAI01><CTAI02></CTAI02><CTAI03></CTAI03><CTAI04></CTAI04><CTAI05></CTAI05><CTAI06></CTAI06></FAXC008><FAXC008><num_factura>VFH3824855</num_factura><num_linea>3</num_linea><cod_producto>AD</cod_producto><fec_despacho>04/01/2010 00:00:00</fec_despacho><num_edicion>6209</num_edicion><cantidad_cred>5</cantidad_cred><monto_descuento>0</monto_descuento><monto_impuesto>0</monto_impuesto><monto_linea>0</monto_linea><CTAP01>  72</CTAP01><CTAP02>   2</CTAP02><CTAP03>  02</CTAP03><CTAP04>  03</CTAP04><CTAP05>072</CTAP05><CTAP06>91</CTAP06><CTAD01></CTAD01><CTAD02></CTAD02><CTAD03></CTAD03><CTAD04></CTAD04><CTAD05></CTAD05><CTAD06></CTAD06><CTAI01></CTAI01><CTAI02></CTAI02><CTAI03></CTAI03><CTAI04></CTAI04><CTAI05></CTAI05><CTAI06></CTAI06></FAXC008></FAXC007></FAXC003></TRANSACCION>"> 



  <cfset LvarXML_ID = "">
  <cfset LvarXML_IS = "">
  <cfsetting requesttimeout="30000">

	 <cftry>
	 
	
	 <cfinvoke
			webservice="http://172.16.5.85:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
			username	= "sinterfaces"
			password	= "interfaces2000"
			method		= "sendToSoinXML"
			returnvariable	= "LvarXML"
			Empresa			= "soin"
			EcodigoSDC		= "86"
			Num_Interfaz		= "701"
			XML_IE			= "#LvarXML_IE#"
			XML_ID			= "#LvarXML_ID#"
			XML_IS			= "#LvarXML_IS#"
			XML_OUT 		= "false"
		>
		<cfoutput>
			<cflog file="invokeInt701" text="Doc.=#LvarDoc#,ID= #LvarXML.ID#,MSG	= #LvarXML.MSG#">
			MSG		= #LvarXML.MSG#<br>
			ID 		= #LvarXML.ID#<br>
			XML_OE 	= #LvarXML.XML_OE#<br>
			XML_OD 	= #LvarXML.XML_OD#<br>
			XML_OS 	= #LvarXML.XML_OS#<br>
		</cfoutput>
	
		<cfcatch type = "Database">   
			<cflog file="invokeInt701" text="Doc..=#LvarDoc#,i=#i#,ERROR=#cfcatch.Message# #cfcatch.Detail#">
			<cfoutput>
				<p>*#cfcatch.message#*</p>
			</cfoutput>
		</cfcatch>
	</cftry>

</cfloop>
