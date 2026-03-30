<!--- 23/06/2006 no se realiza ningún cambio pero se mete en parche porque no se había metido ultima modificación de cfparam del tabindex. --->
<!--- 
********************* TAG de Cuentas Contables de SIF  ***********************************
** Hecho por: Marcel de M.																**
** Fecha: 01 Agosto de 2003																**
** Este TAG crea objetos de tipo TEXT que solicite una Cuenta de Mayor y Detalle de     **
** cuenta. Si la cuenta no acepta movimientos o no existe entonces no carga el campo	**
** oculto con el ID de la cuenta, por lo tanto no sería válido el Submit del Form.		**
** Incluye soporte para manejo de Plan de Cuentas.
******************************************************************************************
--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/cuentasAnexo.js"></script>
<style type="text/css">
	.DocsFrame {
	  visibility: hidden;
	}
</style>

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
<cfparam name="Attributes.comodin" default="_" type="string">
<cfparam name="Attributes.tabindex" default="-1" type="string">

<cfif Attributes.Cformato NEQ "Cformato">
	<cfset Attributes.Cmayor = Attributes.Cmayor & "_" & Attributes.Cformato>
</cfif>

<cfparam name="Request.tagcuentas" default="false">

<!--- Permitir letras en la máscara --->
<cfif not isdefined("request.CFctasConLetras")>
	<cfquery name="rsSQL" datasource="#Attributes.Conexion#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 12
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cfquery datasource="#Attributes.Conexion#">
			insert into Parametros (Ecodigo, Pcodigo, Pvalor, Mcodigo, Pdescripcion)
			values (#session.Ecodigo#, 12, 'N', 'CO', 'Permite letras en Cuenta Financiera')
		</cfquery>
	</cfif>
	<cfset request.CFctasConLetras = (rsSQL.Pvalor EQ "S")>
</cfif>

<!--- Mascara Financiera más grande de la empresa --->
<cfquery name="rsLongitud" datasource="#Session.DSN#" cachedwithin = "#CreateTimeSpan(0, 1, 0, 0)#">
	select coalesce(max( {fn length(CPVformatoF) } ), 40) as longitud
	  from CPVigencia
	 where Ecodigo =  #Session.Ecodigo#
</cfquery>
<cfset longitud = rsLongitud.longitud>

<cfif not Request.tagcuentas>
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
	</script>
	<cfset Request.tagcuentas = true>
</cfif>
	
<script language="JavaScript">
	function doConlisTagCuentas<cfoutput>#Attributes.Ccuenta#</cfoutput>() {
		var params ="";
		<cfoutput>
		params = "?form=#Attributes.form#";
		params += "&id=#Attributes.Ccuenta#";
		params += "&desc=#Attributes.Cdescripcion#";
		params += "&fmt=#Attributes.Cformato#";
		params += "&mayor=#Attributes.Cmayor#";
		params += "&movimiento=#Attributes.movimiento#";
		params += "&auxiliares=#Attributes.auxiliares#";
		params += "&Cnx=#Attributes.Conexion#";
		params += "&Cmayor=" + document.#Attributes.form#.#Attributes.Cmayor#.value;
		</cfoutput>
		popUpWindow("/cfmx/sif/Utiles/ConlisCuentasContables.cfm"+params,250,200,650,350);
	}
	
	<cfoutput>
	function TraeCuentasTag#Attributes.Ccuenta# (mayor,detalle) {
		if (trim(mayor) != "" && trim(document.#Attributes.form#.#Attributes.Cmayor#_mask.value)!='') {
			var params ="";
			var arrfmt = document.#Attributes.form#.#Attributes.Cmayor#_mask.value.substring(5,100).split('-');
			var arrdato = detalle.split('-');
			var cant = 0;
			for (i=0;i<arrdato.length;i++) {
				if (arrfmt[i]){
					if (trim(arrdato[i]).length < trim(arrfmt[i]).length)
					{
						cant = trim(arrfmt[i]).length - trim(arrdato[i]).length;
						for (j=0; j < cant; j++) 
						{
							if (trim(arrdato[i])!="") {
								arrdato[i] = '0' + arrdato[i];
							}
						}
					}
				}
			}
			detalle = arrdato.join('-');
			document.#Attributes.form#.#Attributes.Cformato#.value=detalle;
	
			params = "&id=#Attributes.Ccuenta#";
			params += "&desc=#Attributes.Cdescripcion#";
			params += "&fmt=#Attributes.Cformato#";
			params += "&movimiento=#Attributes.movimiento#";
			params += "&auxiliares=#Attributes.auxiliares#";
			params += "&mayor=#Attributes.Cmayor#";
			params += "&Cnx=#Attributes.Conexion#";
			if (detalle!="") {
					document.all['#Attributes.frame#'].src='/cfmx/sif/Utiles/cuentasqueryAnexo.cfm?Cformato='+detalle+'&Cmayor='+mayor+'&form=#Attributes.form#'+params;
			}
		}
		else {
				document.#Attributes.form#.#Attributes.Cdescripcion#.value="";
				document.#Attributes.form#.#Attributes.Cmayor#_mask.value="";
		}
		return;
	}
	</cfoutput>

	function TraeMascaraCuenta<cfoutput>#Attributes.Ccuenta#</cfoutput>(mayor, detalle) {
			var params ="";
			<cfoutput>
			params = "&id=#Attributes.Ccuenta#";
			params += "&desc=#Attributes.Cdescripcion#";
			params += "&fmt=#Attributes.Cformato#";
			params += "&movimiento=#Attributes.movimiento#";
			params += "&auxiliares=#Attributes.auxiliares#";
			params += "&mayor=#Attributes.Cmayor#";
			params += "&Cnx=#Attributes.Conexion#";
			if (trim(mayor)!="") {
				document.all['#Attributes.frame#'].src='/cfmx/sif/Utiles/cuentasqueryAnexo.cfm?Cmayor='+mayor+'&form=#Attributes.form#'+params;
			}
			else {
			}
			</cfoutput>
		return;
	}
	<cfoutput>
	function right(str, n)
	{
		if (n <= 0)
		   return "";
		else if (n > String(str).length)
		   return str;
		else 
		{
		   var iLen = String(str).length;
		   return String(str).substring(iLen, iLen - n);
		}
	}
	function Cmayor_onblur#Attributes.Ccuenta#(objmayor, objccuenta, objcformato, objcdescripcion, objcmayorid, objcmayormask) {
		if (trim(objmayor.value)!='')
		{
			//objmayor.value = right('0000' + trim(objmayor.value),4);
			objmayor.value = right('0000' + trim(objmayor.value),4);
		}
		else
		{
			objccuenta.value='';
			objcformato.value='';
			objcdescripcion.value='';
			objcmayormask.value='';
			objcmayorid.value='';
		}
		if (trim(objcformato.value) == '') {
			TraeMascaraCuenta#Attributes.Ccuenta#(objmayor.value);
		}
	}
	
	function Cformato_onblur#Attributes.Ccuenta#(obj) {
		var ok = true;	

		if ( (obj.value.indexOf('_') != -1 ) || (obj.value.indexOf('?') != -1 ) || (obj.value.indexOf('x') != -1 ) || (obj.value.indexOf('X') != -1 ) ) {
			ok = false;
			document.#Attributes.form#.#Attributes.Cdescripcion#.value = '';
		}

		return ok;
	}
	
	function conlis_keyup_#Attributes.Ccuenta#(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisTagCuentas#Attributes.Ccuenta#()
		}
	}
	</cfoutput>
	</script>
<cfoutput>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>

	<!---
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = Trim(Evaluate('Attributes.query.' & Attributes.name))>
		<cfset desc = Trim(Evaluate('Attributes.query.' & Attributes.desc))>
	</cfif>
	--->

	<cfquery name="rsMascara" datasource="#Attributes.Conexion#">
		select CPVformatoF as Cmascara
		  from CPVigencia 
		 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		   and Cmayor  = <cfqueryparam value="#Trim(mid(Attributes.query.Cformato,1,4))#" cfsqltype="cf_sql_varchar"> 
		   and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between CPVdesde and CPVhasta
	</cfquery>
</cfif>

  <table border="0" cellspacing="0" cellpadding="0">
    <tr>
		<td nowrap>
			<input name="#Attributes.Cmayor#" maxlength="4" size="4"  type="text" tabindex="#Attributes.tabindex#" 
				onBlur="javascript:Cmayor_onblur#Attributes.Ccuenta#(
					this, 
					#Attributes.Ccuenta#,
					#Attributes.Cformato#,
					#Attributes.Cdescripcion#,
					#Attributes.Cmayor#_id,
					#Attributes.Cmayor#_mask
					);" 
				onFocus="javascript:this.select();"
				onChange="javascript:document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value='';"
				onkeyup="javascript:conlis_keyup_#Attributes.Ccuenta#(event);"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(mid(Attributes.query.Cformato,1,4))#</cfif>">
		</td>
		<td nowrap> 
			<input name="#Attributes.Cformato#" id="#Attributes.Cformato#" maxlength="#longitud#" size="#longitud#" type="text" 
				style="text-transform:uppercase"
				tabindex="#Attributes.tabindex#" 
				onBlur="javascript: this.value = this.value.toUpperCase(); if(trim(this.value)){cuentas_fm(this<cfif request.CFctasConLetras>, true</cfif>);} formato(this,'#Attributes.comodin#'); if ( Cformato_onblur#Attributes.Ccuenta#(this) ) {if (trim(document.#Attributes.form#.#Evaluate('Attributes.Cmayor')#.value) != '') {TraeCuentasTag#Attributes.Ccuenta#(document.#Attributes.form#.#Evaluate('Attributes.Cmayor')#.value, document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value);}}"
				onFocus="javascript:this.select();"
				onKeyUp="javascript: if(cuentas_snumber(this,event<cfif request.CFctasConLetras>, true</cfif>)){ if(Key(event)=='13') {this.blur();}}"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1><cfif len(Trim(Attributes.query.Cformato)) GTE 5>#Trim(Mid(Attributes.query.Cformato,6,len(Attributes.query.Cformato)))#</cfif></cfif>"
			>
			
			<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
			<script language="JavaScript">
				<cfoutput>
				try
				{
					document.#attributes.form#.#attributes.Cformato#.focus();
				}
				catch(e)
				{
				}
				</cfoutput>
			</script>
			</cfif>
			
		</td>
		<td nowrap>
			<input type="text" name="#Attributes.Cdescripcion#" maxlength="80" size="#Attributes.descwidth#" disabled tabindex="-1"
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Cdescripcion)#</cfif>">
		</td>
		<cfif ucase(Attributes.Conlis) EQ "S">
			<td>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas Contables" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTagCuentas#Attributes.Ccuenta#();"></a>		
			</td>
		</cfif>
  </tr>
</table>
	<input type="hidden" name="#Attributes.Ccuenta#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Ccuenta)#</cfif>">
	<input type="hidden" name="#Attributes.Cmayor#_id" value="">
	<input type="hidden" name="#Attributes.Cmayor#_mask" value="<cfif isdefined('rsMascara') and ListLen(rsMascara.columnList) GTE 1>#rsMascara.Cmascara#</cfif>">
	
<iframe name="#Attributes.frame#" marginheight="600" marginwidth="500" frameborder="1" height="0" width="0" scrolling="no" src="about:blank" class="DocsFrame" style="display:none;"></iframe> <!--- class="DocsFrame"--->

	<script language="JavaScript">
		<cfif isdefined("Attributes.query") and Attributes.query.recordcount gt 0 >
			TraeCuentasTag#Attributes.Ccuenta#(document.#Attributes.form#.#Evaluate('Attributes.Cmayor')#.value, document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value)
		</cfif>
	</script>

</cfoutput>	