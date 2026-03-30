<!--- 
********************* TAG de Cuentas Contables de SIF  ***********************************
** Hecho por: Marcel de M.																**
** Fecha: 01 Agosto de 2003																**
** Cambio por: Óscar Bonilla															**
** Fecha: 26 Mayo de 2004																**
** Este TAG crea objetos de tipo TEXT que solicite una Cuenta de Mayor y Detalle de     **
** cuenta. Si la cuenta no acepta movimientos o no existe entonces no carga el campo	**
** oculto con el ID de la cuenta, por lo tanto no sería válido el Submit del Form.	    **
** Incluye soporte para manejo de Plan de Cuentas.                                      **
** solamente funciona con explorer                                                      **
******************************************************************************************
--->
<cfset def = QueryNew("dato") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Ccuenta" default="Ccuenta" type="string">
<cfif Attributes.Ccuenta EQ "Ccuenta">
	<cfparam name="Attributes.CFcuenta" 	default="CFcuenta" type="string">
	<cfparam name="Attributes.Cmayor" 		default="Cmayor" type="string">
	<cfparam name="Attributes.Cformato" 	default="Cformato" type="string">
	<cfparam name="Attributes.Cdescripcion" default="Cdescripcion" type="string">
	<cfparam name="Attributes.frame" 		default="frcuentas" type="string">
<cfelse>
	<cfparam name="Attributes.CFcuenta" 	default="CFcuenta_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cmayor" 		default="Cmayor_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cformato" 	default="Cformato_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cdescripcion" default="Cdescripcion_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.frame" 		default="frcuentas_#Attributes.Ccuenta#" type="string">
</cfif>
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String">
<cfparam name="Attributes.Conlis" default="S" type="String">
<cfparam name="Attributes.query" default="#def#" type="query">
<cfparam name="Attributes.form" default="form1" type="string">
<cfparam name="Attributes.movimiento" default="S" type="string">
<cfparam name="Attributes.auxiliares" default="N" type="string">
<cfparam name="Attributes.descwidth" default="32" type="string">
<cfparam name="Attributes.onchange" default="" type="string">
<cfparam name="Attributes.tabindex" default="-1" type="string">
<cfif Attributes.onchange NEQ "" and right(Attributes.onchange,1) NEQ ";">
	<cfset Attributes.onchange = Attributes.onchange & ";">
</cfif>
<cfparam name="Request.tagcuentas" default="false">

<cfquery name="rsLongitud" datasource="#Session.DSN#" cachedwithin = "#CreateTimeSpan(0, 1, 0, 0)#">
select coalesce(max( {fn length(coalesce(PCEMformato,Cmascara)) } ), 100) as longitud
from CtasMayor CM LEFT JOIN PCEMascaras M ON M.PCEMid = CM.PCEMid
where CM.Ecodigo = #Session.Ecodigo#
</cfquery>


<cfset longitud = rsLongitud.longitud>

<cfparam name="Request.jsMask" default="false" type="boolean">
<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
</cfif>
<cfif not Request.tagcuentas>
<!-- Inicio Common Tag Cuentas -->
	<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<style type="text/css">
		.DocsFrame {
		  visibility: hidden;
		}
	</style>
	<script language="JavaScript">
	var popUpWin=null;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function KeyPressCuentaContable(e, objccuenta, objccuentaF, objcdescripcion) {
		var whichASC = (document.all) ? e.keyCode : e.which;
		if ((whichASC >= 48 && whichASC <= 57) || whichASC == 45) {
			objccuenta.value='';
			objccuentaF.value='';
			objcdescripcion.value='';
			return true;
		}
		else if (whichASC == 9 || whichASC == 0)
		  return true;

		return false;
	}
	function KeyUpCuentaContable(e, objcmayor, objcformato, objmask, conlisArgs) {
		var whichASC = (document.all) ? e.keyCode : e.which;
		if (whichASC == 113) { // 113 IS F12
			objcformato.disableBlur = true;
			mask = objmask.value;
			if (document.selection) {
				var range = document.selection.createRange();
				if (range.text != objcformato.value) {
					range.moveEnd ('textedit', 1);
					if (range.text != '') {
						range.text = '';
						while (objcformato.value.length != 0 && 
						  objcformato.value.charAt (objcformato.value.length - 1) != '-') {
							objcformato.value = objcformato.value.substring (0, objcformato.value.length - 1);
						}
					}
				}
				if (objcformato.value.length >= mask.length - 5) {
					return;
				}
			}
			FormatoCuenta (mask, objcformato);

			popUpWindow('/cfmx/sif/Utiles/ConlisNivelCuenta.cfm' 
				+ conlisArgs 
				+ '&Cmayor=' + escape(objcmayor.value) 
				+ '&Cformato=' + escape(objcformato.value)
						, 250,200,650,350)
		}
	}
	function TraeMascaraCuenta(mayor, frameName, conlisArgs) {
		if (trim(mayor)!="") {
			document.getElementById(frameName).src='/cfmx/sif/Utiles/cuentasquery2.cfm' 
				+ conlisArgs 
				+ '&Cmayor=' + escape(mayor);
		}
	}
	function FormatoCuenta(mask, detalle) {
		var arrfmt = mask.substring(5,100).split('-');
		var arrdato = detalle.value.split('-');
		if (arrfmt.length > 1 && arrdato.length == 1 && arrdato[0].length > arrfmt[0].length) {
			<!--- poner guiones solamente si:
				1) la mascara tiene más de un elemento
				2) el dato capturado no tiene guiones
				3) el dato tiene una longitud mayor a la del primer elemento de la máscara
			 --->
			 var arr2 = new Array();
			 var LongitudDeSubmascara = 0;
			 var numguiones;
			 for (numguiones = 0; numguiones < arrfmt.length; numguiones++) {
				arr2[numguiones] = detalle.value.substring(LongitudDeSubmascara, LongitudDeSubmascara+arrfmt[numguiones].length);
			 	LongitudDeSubmascara += arrfmt[numguiones].length;
			 	if (LongitudDeSubmascara == detalle.value.length) {
					detalle.value = arr2.join('-');
					return;
				}
			 }
		}
		
		for (i = 0; i < arrdato.length && i < arrfmt.length; i++) {
			arrdato[i] = trim(arrdato[i]);
			arrfmt[i] = trim(arrfmt[i]);
			if (arrfmt[i].length > 0 && arrdato[i].length > 0) {
				while (arrdato[i].length < arrfmt[i].length) {
						arrdato[i] = '0' + arrdato[i];
				}
				while (arrdato[i].length > arrfmt[i].length) {
					arrdato[i] = arrdato[i].substring(arrdato[i].length - arrfmt[i].length, arrdato[i].length);
				}
			}
		}
		detalle.value = arrdato.join('-');
	}
	function sbResultadoConLis(valor, descripcion, mascara, Ccuenta_id, mayor, fmt, desc)
	{
		document.getElementById(mayor).value = valor.substring(0,4);
		document.getElementById(fmt).value = valor.substring(5,100);
		document.getElementById(desc).value = descripcion;
		document.getElementById(mayor+"_mask").value = mascara;
		document.getElementById(fmt).focus();
		<cfoutput>
		eval("TraeCuentasTag"+Ccuenta_id+"(document.getElementById(mayor), document.getElementById(fmt))");
		</cfoutput>
	}
	<cfset Request.tagcuentas = true>
</script>
</cfif>
	
<cfoutput>
<!-- Inicio Tag Cuentas para #Attributes.Ccuenta# -->
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset LvarQuery.ConQuery = true>
	<cfset LvarQuery.Nuevo = isdefined('Attributes.query.CFcuenta')>
	<cfif not isdefined('Attributes.query.Ccuenta')>
		<cfthrow message="ERROR en la implementación del nuevo TAG de cuentas, debe mantener el Ccuenta">
	</cfif>
	
	<cfparam name="Attributes.query.Ccuenta" default="-1">
	<cfif LvarQuery.Nuevo>
		<cfset LvarQuery.CFcuenta 		= Attributes.query.CFcuenta>
		<cfset LvarQuery.Ccuenta 		= Attributes.query.Ccuenta>
		<cfif isdefined("Attributes.query.CFdescripcion")>
			<cfset LvarQuery.CFdescripcion 	= Trim(Attributes.query.CFdescripcion)>
		<cfelse>
			<cfset LvarQuery.CFdescripcion 	= Trim(Attributes.query.Cdescripcion)>
		</cfif>
		<cfif isdefined("Attributes.query.CFformato")>
			<cfset LvarQuery.CFformato = Trim(Attributes.query.CFformato)>
		<cfelse>
			<cfset LvarQuery.CFformato = Trim(Attributes.query.Cformato)>
		</cfif>
	<cfelse>
		<cfquery name="rsCFinanciera" datasource="#Attributes.Conexion#">
			select CFcuenta, CFdescripcion, CFformato
			  from CFinanciera f
			 where Ecodigo = #session.Ecodigo#
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.query.Ccuenta#" null="#Attributes.query.Ccuenta EQ''#">
			order by CFcuenta
		</cfquery>
		<cfset LvarQuery.CFcuenta 		= rsCFinanciera.CFcuenta>
		<cfset LvarQuery.Ccuenta 		= Attributes.query.Ccuenta>
		<cfset LvarQuery.CFdescripcion 	= Trim(rsCFinanciera.CFdescripcion)>
		<cfset LvarQuery.CFformato 		= Trim(rsCFinanciera.CFformato)>
	</cfif>

	<cfset LvarQuery.Cmayor = mid(LvarQuery.CFformato,1,4)>
	<cfif len(LvarQuery.CFformato) GT 4>
		<cfset LvarQuery.CFdetalle = mid(LvarQuery.CFformato,6,len(LvarQuery.CFformato))>
	<cfelse>
		<cfset LvarQuery.CFdetalle = "">
	</cfif>
	
	<cfquery name="rsMascara" datasource="#Attributes.Conexion#">
		select Cmascara 
		from CtasMayor 
		where Ecodigo = #Session.Ecodigo#
		  and Cmayor = '#LvarQuery.Cmayor#'
	</cfquery>
<cfelse>
	<cfset LvarQuery.ConQuery = false>
	<cfset LvarQuery.Nuevo    = false>
</cfif>

<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap>
			<input name="#Attributes.Cmayor#" id="#Attributes.Cmayor#" maxlength="4" size="4"  type="text" 
				onBlur="javascript:Cmayor_onblur#Attributes.Ccuenta#(
					this, 
					#Attributes.Ccuenta#,
					#Attributes.CFcuenta#,
					#Attributes.Cformato#,
					#Attributes.Cdescripcion#,
					#Attributes.Cmayor#_id,
					#Attributes.Cmayor#_mask
					);" 
				onFocus="javascript:this.select();"
				onChange="javascript:document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value='';"
				tabindex="#Attributes.tabindex#"
				onKeyPress="javascript:if ((document.layers) ? e.which : event.keyCode == 13) return false; else return true;"
				value="<cfif LvarQuery.ConQuery>#LvarQuery.Cmayor#</cfif>">
		</td>
		<td nowrap> 
			<input name="#Attributes.Cformato#" id="#Attributes.Cformato#" maxlength="#longitud-5#" size="#longitud#" type="text"
			tabindex="#Attributes.tabindex+1#"
			onBlur="javascript:TraeCuentasTag#Attributes.Ccuenta#(form.#Attributes.Cmayor#, this);"
			onFocus="javascript:this.select();"<!--- onChange="javascript:TraeCuentasTag#Attributes.Ccuenta#(form.#Attributes.Cmayor#, this);" --->
			onKeyUp="javascript:return KeyUpCuentaContable(event,form.#Attributes.Cmayor#,this, form.#Attributes.Cmayor#_mask, ConlisArguments#Attributes.Ccuenta#());"
			onKeyPress="javascript:return KeyPressCuentaContable(event, form.#Attributes.Ccuenta#, form.#Attributes.CFcuenta#, form.#Attributes.Cdescripcion#);"
			value="<cfif LvarQuery.ConQuery>#LvarQuery.CFdetalle#</cfif>">
		</td>
		<td nowrap>
			<input type="text" name="#Attributes.Cdescripcion#" id="#Attributes.Cdescripcion#" maxlength="80" size="#Attributes.descwidth#" disabled tabindex="-1"
			value="<cfif LvarQuery.ConQuery>#LvarQuery.CFdescripcion#</cfif>">
			<cfif ucase(Attributes.Conlis) EQ "S">
				<a href="javascript:doConlisTagCuentas#Attributes.Ccuenta#();" tabindex="-1">
					<img class="imgIconConlist" 
						alt="Lista de Cuentas Financieras" 
						name="imagen" 
						width="18" height="14" 
						border="0" align="absmiddle" 
						onMouseOver="document.getElementById('#Attributes.Cformato#').disableBlur = true;"
						onMouseDown="document.getElementById('#Attributes.Cformato#').disableBlur = true;"
						onMouseUp  ="document.getElementById('#Attributes.Cformato#').disableBlur = false;"
						onMouseOut ="document.getElementById('#Attributes.Cformato#').disableBlur = false;"
					>
				</a>		
			</cfif>
		</td>
  </tr>
</table>
	<input type="hidden" name="#Attributes.Ccuenta#" 	id="#Attributes.Ccuenta#" 	value="<cfif LvarQuery.ConQuery>#LvarQuery.Ccuenta#</cfif>">
	<input type="hidden" name="#Attributes.CFcuenta#" 	id="#Attributes.CFcuenta#" 	value="<cfif LvarQuery.Nuevo>#LvarQuery.CFcuenta#</cfif>">
	<input type="hidden" name="#Attributes.Cmayor#_id" 	id="#Attributes.Cmayor#_id"	value="">
	<input type="hidden" name="#Attributes.Cmayor#_mask" id="#Attributes.Cmayor#_mask" value="<cfif isdefined('rsMascara') and ListLen(rsMascara.columnList) GTE 1>#rsMascara.Cmascara#</cfif>">
<iframe name="#Attributes.frame#" id="#Attributes.frame#" scrolling="yes" src="about:blank" 
	marginheight="0" marginwidth="0" frameborder="0"
	height="0" width="0" 
	class="DocsFrame"
	>
</iframe>

<script language="JavaScript">
	function ConlisArguments#Attributes.Ccuenta#() {
		return ("?form=#JSStringFormat( URLEncodedFormat( Attributes.form ))
			  #&id=#JSStringFormat( URLEncodedFormat( Attributes.Ccuenta ))
			  #&idF=#JSStringFormat( URLEncodedFormat( Attributes.CFcuenta ))
			  #&desc=#JSStringFormat( URLEncodedFormat( Attributes.Cdescripcion ))
			  #&fmt=#JSStringFormat( URLEncodedFormat( Attributes.Cformato ))
			  #&mayor=#JSStringFormat( URLEncodedFormat( Attributes.Cmayor ))
			  #&movimiento=#JSStringFormat( URLEncodedFormat( Attributes.movimiento ))
			  #&auxiliares=#JSStringFormat( URLEncodedFormat( Attributes.auxiliares ))
			  #&Cnx=#JSStringFormat( URLEncodedFormat( Attributes.Conexion ))#");
	}

	function doConlisTagCuentas#Attributes.Ccuenta#() {
		popUpWindow('/cfmx/sif/Utiles/ConlisCuentasFinancieras.cfm' +
			ConlisArguments#Attributes.Ccuenta#() 
				+ '&Cmayor='   + escape(document.#Attributes.form#.#Attributes.Cmayor#.value)
				+ '&CFdetalle=' + escape(document.#Attributes.form#.#Attributes.Cformato#.value)
			,250,200,650,400);
	}
	function TraeCuentasTag#Attributes.Ccuenta#(objMayor, objDetalle) {
		<cfif Attributes.onchange NEQ "">
		if (objMayor.value != '#LvarQuery.CMayor#' || objDetalle.value != '#LvarQuery.CFdetalle#') #Attributes.onchange#
		</cfif>
		if (objDetalle.disableBlur) {
			objDetalle.disableBlur = false;
			return;
		}
		if (trim(objMayor.value) != "" && trim(document.#Attributes.form#.#Attributes.CMayor#_mask.value)!='') {
			FormatoCuenta (document.#Attributes.form#.#Attributes.CMayor#_mask.value, objDetalle);
			if (objDetalle.value!="") {
				document.getElementById('#Attributes.frame#').src='/cfmx/sif/Utiles/cuentasquery2.cfm'
					+ ConlisArguments#Attributes.Ccuenta#() 
					+ '&CFDetalle='    + escape(objDetalle.value)
					+ '&CMayor='    + escape(objMayor.value);
			}
		} else {
			document.#Attributes.form#.#Attributes.Cdescripcion#.value="";
			document.#Attributes.form#.#Attributes.CMayor#_mask.value="";
		}
	}

	function TraeCFcuentaTag#Attributes.Ccuenta#(CFcuenta) 
	{
		<cfif Attributes.onchange NEQ "">
		if (mayor.value != '#LvarQuery.Cmayor#' || detalle.value != '#LvarQuery.CFdetalle#') #Attributes.onchange#
		</cfif>
		if (trim(CFcuenta) != "")
		{
			document.getElementById('#Attributes.frame#').src='/cfmx/sif/Utiles/cuentasquery2.cfm'
				+ ConlisArguments#Attributes.Ccuenta#() 
				+ '&CFcuenta='    + escape(CFcuenta);
		}
		else 
		{
			document.#Attributes.form#.#Attributes.Cdescripcion#.value="";
			document.#Attributes.form#.#Attributes.Cmayor#_mask.value="";
		}
	}

	function Cmayor_onblur#Attributes.Ccuenta#(objmayor, objccuenta, objccuentaF, objcformato, objcdescripcion, objcmayorid, objcmayormask) {
		<cfif Attributes.onchange NEQ "">
		<cfoutput>
		if (objmayor.value != '#LvarQuery.Cmayor#') #Attributes.onchange#
		</cfoutput>
		</cfif>
		if (trim(objmayor.value)==''){
			objccuenta.value='';
			objccuentaF.value='';
			objcformato.value='';
			objcdescripcion.value='';
			objcmayormask.value='';
			objcmayorid.value='';
		}
		else
		{
			var LvarCerosV = "0000" + trim(objmayor.value);
			var LvarCerosN = LvarCerosV.length;
			objmayor.value = LvarCerosV.substring(LvarCerosN-4,LvarCerosN);
		}
		if (trim(objcformato.value) == '') {
			TraeMascaraCuenta(objmayor.value, '#JSStringFormat(Attributes.frame)#',
				ConlisArguments#Attributes.Ccuenta#());
		}
	}
</script>
</cfoutput>