<cfinclude template="cuentas2.cfm"><cfreturn>
<!--- 
********************* TAG de Cuentas Contables de SIF  ***********************************
** Hecho por: Marcel de M.																**
** Fecha: 01 Agosto de 2003																**
** Este TAG crea objetos de tipo TEXT que solicite una Cuenta de Mayor y Detalle de     **
** cuenta. Si la cuenta no acepta movimientos o no existe entonces no carga el campo	**
** oculto con el ID de la cuenta, por lo tanto no sería válido el Submit del Form.	    **
** Incluye soporte para manejo de Plan de Cuentas.                                      **
** solamente funciona con explorer                                                      **
******************************************************************************************
--->
<cfset def = QueryNew("dato") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String">
<cfparam name="Attributes.Conlis" default="S" type="String">
<cfparam name="Attributes.query" default="#def#" type="query">
<cfparam name="Attributes.Cmayor" default="Cmayor" type="string">
<cfparam name="Attributes.Cformato" default="Cformato" type="string">
<cfparam name="Attributes.Cdescripcion" default="Cdescripcion" type="string">
<cfparam name="Attributes.Ccuenta" default="Ccuenta" type="string">
<cfparam name="Attributes.form" default="form1" type="string">
<cfparam name="Attributes.movimiento" default="N" type="string">
<cfparam name="Attributes.auxiliares" default="N" type="string">
<cfparam name="Attributes.frame" default="frcuentas" type="string">
<cfparam name="Attributes.descwidth" default="32" type="string">
<cfparam name="Attributes.tabindex" default="-1" type="string">


<cfif Attributes.Cformato NEQ "Cformato">
	<cfset Attributes.Cmayor = Attributes.Cmayor & "_" & Attributes.Cformato>
</cfif>

<cfparam name="Request.tagcuentas" default="false">

<cfquery name="rsLongitud" datasource="#Session.DSN#" cachedwithin = "#CreateTimeSpan(0, 1, 0, 0)#">
select coalesce(max(char_length(Cmascara)),100) as longitud
from CtasMayor 
where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset longitud = rsLongitud.longitud>

<cfif not Request.tagcuentas>
	<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<style type="text/css">
		.DocsFrame {
		  visibility: hidden;
		}
	</style>
	<script language="JavaScript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function KeyPressCuentaContable(event, objccuenta, objcdescripcion) {
		var whichASC = (document.layers) ? e.which : event.keyCode;
		if (whichASC >= 48 && whichASC <= 57 || whichASC == 45) {
			objccuenta.value='';
			objcdescripcion.value='';
			return true;
		}
		return false;
	}
	function KeyUpCuentaContable(event, objcmayor, objcformato, objmask, conlisArgs) {
		var whichASC = (document.layers) ? e.which : event.keyCode;
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

			popUpWindow('/cfmx/sif/Utiles/ConlisNivelCuenta.cfm' +
				conlisArgs + '&Cmayor=' + 
				escape(objcmayor.value) + '&Cformato=' + escape(objcformato.value), 250,200,650,350)
		}
	}
	function TraeMascaraCuenta(mayor, frameName, conlisArgs) {
		if (trim(mayor)!="") {
			document.all[frameName].src='/cfmx/sif/Utiles/cuentasquery.cfm' +
				conlisArgs + '&Cmayor=' + escape(mayor);
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
	</script>
	<cfset Request.tagcuentas = true>
</cfif>
	
<script language="JavaScript">
<cfoutput><!--
	function ConlisArguments#Attributes.Ccuenta#() {
		return ("?form=#JSStringFormat( URLEncodedFormat( Attributes.form ))
			  #&id=#JSStringFormat( URLEncodedFormat( Attributes.Ccuenta ))
			  #&desc=#JSStringFormat( URLEncodedFormat( Attributes.Cdescripcion ))
			  #&fmt=#JSStringFormat( URLEncodedFormat( Attributes.Cformato ))
			  #&mayor=#JSStringFormat( URLEncodedFormat( Attributes.Cmayor ))
			  #&movimiento=#JSStringFormat( URLEncodedFormat( Attributes.movimiento ))
			  #&auxiliares=#JSStringFormat( URLEncodedFormat( Attributes.auxiliares ))
			  #&Cnx=#JSStringFormat( URLEncodedFormat( Attributes.Conexion ))#");
	}
	function doConlisTagCuentas#Attributes.Ccuenta#() {
		popUpWindow('/cfmx/sif/Utiles/ConlisCuentasContables.cfm' +
			ConlisArguments#Attributes.Ccuenta#(),250,200,650,350);
	}
	function TraeCuentasTag#Attributes.Ccuenta#(mayor, detalle) {
		if (detalle.disableBlur) {
			detalle.disableBlur = false;
			return;
		}
		if (trim(mayor.value) != "" && trim(document.#Attributes.form#.#Attributes.Cmayor#_mask.value)!='') {
			FormatoCuenta (document.#Attributes.form#.#Attributes.Cmayor#_mask.value, detalle);
			if (detalle.value!="") { 
				document.all['#Attributes.frame#'].src='/cfmx/sif/Utiles/cuentasquery.cfm' +
					ConlisArguments#Attributes.Ccuenta#() + '&Cformato=' +
					escape(detalle.value) + '&Cmayor='+escape(mayor.value);
			}
		} else {
			document.#Attributes.form#.#Attributes.Cdescripcion#.value="";
			document.#Attributes.form#.#Attributes.Cmayor#_mask.value="";
		}
	}

	function Cmayor_onblur#Attributes.Ccuenta#(objmayor, objccuenta, objcformato, objcdescripcion, objcmayorid, objcmayormask) {
		if (trim(objmayor.value)==''){
			objccuenta.value='';
			objcformato.value='';
			objcdescripcion.value='';
			objcmayormask.value='';
			objcmayorid.value='';
		}
		if (trim(objcformato.value) == '') {
			TraeMascaraCuenta(objmayor.value, '#JSStringFormat(Attributes.frame)#',
				ConlisArguments#Attributes.Ccuenta#());
		}
	}
</cfoutput>//-->
</script>
<cfoutput>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfquery name="rsMascara" datasource="#Attributes.Conexion#">
		select Cmascara 
		from CtasMayor 
		where Ecodigo = #Session.Ecodigo#
		  and Cmayor = '#Trim(mid(Attributes.query.Cformato,1,4))#'
	</cfquery>
</cfif>
  <table border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td nowrap>
			<input name="#Attributes.Cmayor#" maxlength="4" size="4"  type="text" 
				onBlur="javascript:Cmayor_onblur#Attributes.Ccuenta#(
					this, 
					#Attributes.Ccuenta#,
					#Attributes.Cformato#,
					#Attributes.Cdescripcion#,
					#Attributes.Cmayor#_id,
					#Attributes.Cmayor#_mask
					);" 
				onFocus="javascript:this.select();"
				tabindex="#Attributes.tabindex#"
				onChange="javascript:document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value='';"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(mid(Attributes.query.Cformato,1,4))#</cfif>">
		</td>
		<td nowrap> 
			<input name="#Attributes.Cformato#" maxlength="#longitud-5#" size="#longitud#" type="text"
			onBlur="javascript:TraeCuentasTag#Attributes.Ccuenta#(form.#Attributes.Cmayor#, this);"
			onFocus="javascript:this.select();"
			tabindex="#Attributes.tabindex+1#"
			onChange="javascript:TraeCuentasTag#Attributes.Ccuenta#(form.#Attributes.Cmayor#, this);"
			onKeyUp="javascript:return KeyUpCuentaContable(event,form.#Attributes.Cmayor#,this, form.#Attributes.Cmayor#_mask, ConlisArguments#Attributes.Ccuenta#());"
			onKeyPress="javascript:return KeyPressCuentaContable(event, form.#Attributes.Ccuenta#, form.#Attributes.Cdescripcion#);"
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1><cfif len(Trim(Attributes.query.Cformato)) GTE 5>#Trim(Mid(Attributes.query.Cformato,6,len(Attributes.query.Cformato)))#</cfif></cfif>">
		</td>
		<td nowrap>
			<input type="text" name="#Attributes.Cdescripcion#" maxlength="80" size="#Attributes.descwidth#" disabled tabindex="-1"
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Cdescripcion)#</cfif>">
			<cfif ucase(Attributes.Conlis) EQ "S">
				<a href="javascript:doConlisTagCuentas#Attributes.Ccuenta#()" tabindex="-1">
				<img class="imgIconConlist" alt="Lista de Cuentas Contables" 
				name="imagen" width="18" height="14" border="0" align="absmiddle" ></a>		
			</cfif>
		</td>
  </tr>
</table>
		<input type="hidden" name="#Attributes.Ccuenta#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Ccuenta)#</cfif>">
		<input type="hidden" name="#Attributes.Cmayor#_id" value="">
		<input type="hidden" name="#Attributes.Cmayor#_mask" size="#longitud#" value="<cfif isdefined('rsMascara') and ListLen(rsMascara.columnList) GTE 1>#rsMascara.Cmascara#</cfif>">
	
<iframe name="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0"
	height="0" width="0" 
	scrolling="yes" src="about:blank" class="DocsFrame"></iframe>

</cfoutput>	