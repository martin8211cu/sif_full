<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!--- 
********************* TAG de Cuentas Contables de SIF  ***********************************
** Hecho por: Marcel de M.																**
** Fecha: 01 Agosto de 2003																**
** Cambio por: scar Bonilla															**
** Fecha: 26 Mayo de 2004																**
** Este TAG crea objetos de tipo TEXT que solicite una Cuenta de Mayor y Detalle de     **
** cuenta. Si la cuenta no acepta movimientos o no existe entonces no carga el campo	**
** oculto con el ID de la cuenta, por lo tanto no sera vlido el Submit del Form.	    **
** Incluye soporte para manejo de Plan de Cuentas.                                      **
** solamente funciona con explorer                                                      **
** Cambio por: Oscar Bonilla y Gustavo Gutiérrez										** 
** Fecha: 01 Junio de 2005  															**
** Se agregaron 2 parámetros para que el manejo de cuenta intercompañías                **
** Si Intercompany es true presenta un combo de compañías al lado de tag de cuentas     **
** para que pueda seleccionar una cuenta de la compañía selecionada                     **
** el parametro onchangeIntercompany es para ejecutar una funcion en javascript         **
** cuando se cambia de compañía en el combo                                             **
**                                                                                      **
** Modificado por: Ana Villavicencio													**
** Fecha: 23 de febrero del 2006														**
** Motivo: Agregar atributo de display en none al iframe del tag						**
** 		   Se corrigió navegacion de tab.												**
** 		   Se agregó la funcion conlis_keyup, para q funcionara el F2.					**
**                                                                                      **
** Modificado por: Steve Vado Rodríguez													**
** Fecha: 02 de marzo del 2006														    **
** Motivo: Se modificó la función doConlisTagCuentas para que ampliara la pantalla      **
**		   ya que cuando aparece mostrar todas las cuentas y el combo de oficinas sale  **
** 		   cortado. La posición anterior era 250,200,650,400.                           **
******************************************************************************************
--->

<cfset def = QueryNew("dato") >

<!--- Parmetros del TAG --->
<cfparam name="Attributes.Ccuenta" 					default="Ccuenta" type="string">

<cfif not isdefined("request.cf_cuentas.Ccuenta")>
	<cfset request.cf_cuentas.Ccuenta = "">
</cfif>
<cfif ListFindNoCase(request.cf_cuentas.Ccuenta,Attributes.Ccuenta) GT 0>
	<cf_errorCode	code = "50619" msg = "Esta utilizando el tag CF_cuentas más de una vez en la pantalla y no coloco o repitio el atributo 'Ccuenta'">
</cfif>
<cfset request.cf_cuentas.Ccuenta = "#request.cf_cuentas.Ccuenta#,#Attributes.Ccuenta#" >

<cfif Attributes.Ccuenta EQ "Ccuenta">
	<cfparam name="Attributes.CFcuenta" 			default="CFcuenta" type="string">
	<cfparam name="Attributes.Cmayor" 				default="Cmayor" type="string">
	<cfparam name="Attributes.Cformato" 			default="Cformato" type="string">
	<cfparam name="Attributes.Cdescripcion" 		default="Cdescripcion" type="string">
	<cfparam name="Attributes.frame" 				default="frcuentas" type="string">
<cfelse>
	<cfparam name="Attributes.CFcuenta" 			default="CFcuenta_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cmayor" 				default="Cmayor_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cformato" 			default="Cformato_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.Cdescripcion" 		default="Cdescripcion_#Attributes.Ccuenta#" type="string">
	<cfparam name="Attributes.frame" 				default="frcuentas_#Attributes.Ccuenta#" type="string">
</cfif>
<cfparam name="Attributes.Conexion" 				default="#Session.DSN#" type="String">
<cfparam name="Attributes.Conlis" 					default="S" type="String">
<cfparam name="Attributes.query" 					default="#def#" type="query">
<cfparam name="Attributes.form" 					default="form1" type="string">
<cfparam name="Attributes.movimiento" 				default="S" type="string">
<cfparam name="Attributes.auxiliares" 				default="N" type="string"> 		<!--- S=Solo Auxiliares, N=Auxiliares y Conta, C=Solo Conta --->
<cfparam name="Attributes.descwidth" 				default="32" type="string">
<cfparam name="Attributes.onchange" 				default="" type="string">
<cfparam name="Attributes.tabindex" 				default="-1" type="string">
<cfparam name="Attributes.Intercompany"  			default="no" type="boolean">
<cfparam name="Attributes.onchangeIntercompany"  	default="" type="string">
<cfparam name="Attributes.Cmayores"  				default="" type="string">
<cfparam name="Attributes.igualTabFormato"         	default="N" type="string"> 		<!--- Iguala el tabindex del formato y la cuenta de mayor. --->
<cfparam name="Attributes.fecha" 					default="" type="string"> 		<!--- Default Periodo Mes Auxiliares --->
<cfparam name="Attributes.readOnly" 				default="false" type="string"> 	<!--- Permite bloquear el valor en modo cambio --->

<cfparam name="Attributes.NoVerificarPres" 			default="no" type="boolean"> 	<!--- Default Periodo Mes Auxiliares --->

<cfparam name="Attributes.FirstColWidth" 			default="21" type="numeric"> 	<!--- Permite bloquear el valor en modo cambio --->

<cfparam name="Attributes.cf_conceptoPago" 			default="" type="string"> 		<!--- Permite interactual con tag cf_conceptoPago --->

<!--- Permite interactual con tag cf_conceptoPago --->
<cfif Attributes.cf_conceptoPago NEQ "">
	<cfparam name="request.cf_conceptoPago"			default="#structNew()#">
	<cfparam name="request.cf_conceptoPago.names"	default="">
	<cfset request.cf_conceptoPago.names = listappend(request.cf_conceptoPago.names,Attributes.cf_conceptoPago)>
</cfif>

<cfif Attributes.onchange NEQ "" and right(Attributes.onchange,1) NEQ ";">
	<cfset Attributes.onchange = Attributes.onchange & ";">
</cfif>
<cfif Attributes.onchangeIntercompany NEQ "" and right(Attributes.onchangeIntercompany,1) NEQ ";">
	<cfset Attributes.onchangeIntercompany = Attributes.onchangeIntercompany & ";">
</cfif>
<cfif Attributes.tabindex EQ "-1" AND Attributes.igualTabFormato EQ "N">
	<cfset Attributes.tabindex = "0">
	<cfset Attributes.igualTabFormato = "S">
</cfif>

<cfparam name="Attributes.Ctipo" 					default="" type="string">
<cfparam name="Request.tagcuentas" 					default="false">

<!-- Inicio Tag Cuentas para #Attributes.Ccuenta# -->
<cfparam name="Attributes.CFdescripcion" 			default="Attributes.Cdescripcion">
<cfparam name="Attributes.CFformato" 				default="Attributes.Cformato">

<cfparam name="Attributes.alt" 					default="El campo Cuenta" type="string">

<!--- 
	Attributes.Ocodigo y Attributes.CFid son Excluyentes:
		Attributes.Ocodigo:	Permite realizar TODAS las verificaciones de cuentas
		Attributes.CFid:	Determina el Ocodigo y además de realizar todas las verificaciones
							realizar el control de mascaras por centro funcional
		Posibles valores:
			""				(En blanco) Se ignora
			"1234"			(Un numero) Es el ID de Ocodigo/CFid fijo correspondiente
			"NAME"			(Letras) Es el nombre del campo en pantalla de Ocodigo/CFid, que se accesará:
								document.#Attributes.form#.#Attributes.Ocodigo/CFid#.value
			"FORM.NAME"		(Incluye punto ".") Es el nombre del form y campo en pantalla de Ocodigo/CFid, que se accesará:
								document.#Attributes.Ocodigo/CFid#.value
							Cuando se usa con NAME o FORM.NAME, se actualizará el onblur de dicho campo
							para que la pantalla quede consistente
--->
<cfparam name="Attributes.Ocodigo" 					default="" type="string">
<cfparam name="Attributes.CFid" 					default="" type="string">

<cfif trim(Attributes.Ocodigo) NEQ "" AND trim(Attributes.CFid) NEQ "">
	<cf_errorCode	code = "50620" msg = "Los Atributos Ocodigo y CFid son excluyentes">
</cfif>

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
			insert into Parametros (Ecodigo, Pcodigo, Pvalor, Mcodigo, Pdescripcion, BMUsucodigo)
			values (#session.Ecodigo#, 12, 'N', 'CO', 'Permite letras en Cuenta Financiera', #session.Usucodigo#)
		</cfquery>
	</cfif>
	<cfset request.CFctasConLetras = (rsSQL.Pvalor EQ "S")>
</cfif>

<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset LvarQuery.ConQuery = true>

	<cfif isdefined ("Attributes.query.Ccuenta")>
		<cfset LvarQuery.Ccuenta 		= evaluate ("Attributes.query.Ccuenta")>
	<cfelseif isdefined ("Attributes.query.#Attributes.Ccuenta#")>
		<cfset LvarQuery.Ccuenta 		= evaluate ("Attributes.query.#Attributes.Ccuenta#")>
	<cfelse>
		<cf_errorCode	code = "50621" msg = "ERROR en la implementacin del nuevo TAG de cuentas, debe mantener el Ccuenta">
	</cfif>
	
	<cfif isdefined ("Attributes.query.CFcuenta")>
		<cfset LvarQuery.CFcuenta 		= evaluate ("Attributes.query.CFcuenta")>
		<cfset LvarQuery.Nuevo = true>
	<cfelseif isdefined ("Attributes.query.#Attributes.CFcuenta#")>
		<cfset LvarQuery.CFcuenta 		= evaluate ("Attributes.query.#Attributes.CFcuenta#")>
		<cfset LvarQuery.Nuevo = true>
	<cfelse>
		<cfset LvarQuery.Nuevo = false>
	</cfif>
	<cfif LvarQuery.Nuevo AND trim(LvarQuery.CFcuenta) NEQ "">
		<cfquery name="rsCFinanciera" datasource="#Attributes.Conexion#">
			select Ecodigo, CFdescripcion, CFformato, Ccuenta
			  from CFinanciera f
			 where CFcuenta = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarQuery.CFcuenta#" voidnull>
			 <cfif not Attributes.Intercompany>
			   and Ecodigo =  #session.Ecodigo#
			 </cfif>
		</cfquery>
		<cfset LvarQuery.CFdescripcion 	= Trim(rsCFinanciera.CFdescripcion)>
		<cfset LvarQuery.CFformato 		= Trim(rsCFinanciera.CFformato)>
		<cfset LvarQuery.Ccuenta 		= rsCFinanciera.Ccuenta>
	<cfelse>
		<cfquery name="rsCFinanciera" datasource="#Attributes.Conexion#">
			select Ecodigo, CFcuenta, CFdescripcion, CFformato
			  from CFinanciera f
			 where Ccuenta = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarQuery.Ccuenta#" voidnull>
			 <cfif not Attributes.Intercompany>
			   and Ecodigo =  #session.Ecodigo#
			 </cfif>
			order by CFcuenta
		</cfquery>
		<cfset LvarQuery.CFcuenta 		= rsCFinanciera.CFcuenta>
		<cfset LvarQuery.CFdescripcion 	= Trim(rsCFinanciera.CFdescripcion)>
		<cfset LvarQuery.CFformato 		= Trim(rsCFinanciera.CFformato)>
	</cfif>

	<cfset LvarQuery.Cmayor = mid(LvarQuery.CFformato,1,4)>
	<cfif len(LvarQuery.CFformato) GT 4>
		<cfset LvarQuery.CFdetalle = mid(LvarQuery.CFformato,6,len(LvarQuery.CFformato))>
	<cfelse>
		<cfset LvarQuery.CFdetalle = "">
	</cfif>
<cfelse>
	<cfset LvarQuery.ConQuery = false>
	<cfset LvarQuery.Nuevo    = false>
</cfif>

<cfif NOT Attributes.Intercompany>
	<cfset LvarEcodigo = Session.Ecodigo>
<cfelse>
	<cfquery name="rsIntercompanies" datasource="#Attributes.Conexion#">
		select  Ecodigo, Edescripcion 
		  from Empresas
		 where cliente_empresarial =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
	<cfif NOT LvarQuery.ConQuery>
		<cfset LvarEcodigo = Session.Ecodigo>
	<cfelse>
		<cfif Len(Trim(rsCFinanciera.Ecodigo))>
			<cfset LvarEcodigo = rsCFinanciera.Ecodigo>
		<cfelse>
			<cfset LvarEcodigo = Session.Ecodigo>
		</cfif>
	</cfif>
</cfif>

<cfif LvarQuery.ConQuery and isdefined("LvarQuery.Cmayor") and Len(Trim(LvarQuery.Cmayor))>
	<cfquery name="rsMascara" datasource="#Attributes.Conexion#">
		select CPVformatoF as Cmascara
		  from CPVigencia 
		 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		   and Cmayor  = <cfqueryparam value="#LvarQuery.Cmayor#" cfsqltype="cf_sql_varchar"> 
		   and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between CPVdesde and CPVhasta
	</cfquery>
</cfif>

<!--- Mascara Financiera más grande de la empresa --->
<cfquery name="rsLongitud" datasource="#Session.DSN#" cachedwithin = "#CreateTimeSpan(0, 1, 0, 0)#">
	select coalesce(max( {fn length(CPVformatoF) } ), 40) as longitud
	  from CPVigencia
	 where Ecodigo =  #LvarEcodigo#
</cfquery>
<cfset longitud = rsLongitud.longitud>

</cfsilent>
<cfif not isdefined("request.IFramesStatus.#Attributes.form#")><CF_IFramesStatus form="#Attributes.form#" action="initForm"></cfif>
<cfparam name="Request.jsMask" default="false" type="boolean">
<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
</cfif>
<cfif not Request.tagcuentas>
	<!-- Rutinas de Control del CF_cuentas para el documento -->
	<cfif not isdefined("request.scriptMontoDefinition")>
		<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cfset request.scriptMontoDefinition = 1>
	</cfif>
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
	
	
	function KeyPressCuentaFinanciera(e, objccuenta, objccuentaF, objcdescripcion) {
		var whichASC = (document.all) ? e.keyCode : e.which;
	<cfif request.CFctasConLetras>
		if ((whichASC >= 48 && whichASC <= 57) || (whichASC >= 65 && whichASC <= 90) || (whichASC >= 97 && whichASC <= 122) || whichASC == 45) {
	<cfelse>
		if ((whichASC >= 48 && whichASC <= 57) || whichASC == 45) {
	</cfif>
			objccuenta.value='';
			objccuentaF.value='';
			objcdescripcion.value='';
			return true;
		}
		else if (whichASC == 8 || whichASC == 9 || whichASC == 0)
		  return true;

		return false;
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
				1) la mascara tiene ms de un elemento
				2) el dato capturado no tiene guiones
				3) el dato tiene una longitud mayor a la del primer elemento de la mscara
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
		try {document.getElementById(fmt).focus();} catch (e) {};
		<cfoutput>
		eval("TraeCuentasTag"+Ccuenta_id+"(document.getElementById(mayor), document.getElementById(fmt))");
		</cfoutput>
	}
	var GvarCF_cuentas = false;
	<cfset Request.tagcuentas = true>
</script>
</cfif>
	
<cfoutput>
<!-- CF_cuentas: #Attributes.Ccuenta#-->
<div style="display: inline-block; white-space: nowrap;">
	<cfif Attributes.Intercompany>
	<select name="Ecodigo_#Attributes.Ccuenta#" id="Ecodigo_#Attributes.Ccuenta#"   <cfif Attributes.readOnly eq "true">readonly="yes"</cfif> onChange="javascript:
					<cfif Attributes.onchangeIntercompany NEQ "">
					#Attributes.onchangeIntercompany#
					</cfif>
					document.#Attributes.form#.#Evaluate('Attributes.Cmayor')#.value='';
					document.#Attributes.form#.#Evaluate('Attributes.Ccuenta')#.value='';
					document.#Attributes.form#.#Evaluate('Attributes.CFcuenta')#.value='';
					document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value='';
					document.#Attributes.form#.#Evaluate('Attributes.Cdescripcion')#.value='';
					LvarEcodigo_#Attributes.Ccuenta# = this.value;
					"					
				tabindex="#Attributes.tabindex#" 
			>
			<cfloop query="rsIntercompanies">
				<option value="#rsIntercompanies.Ecodigo#"<cfif LvarEcodigo eq rsIntercompanies.Ecodigo> selected</cfif>>#left(rsIntercompanies.Edescripcion,Attributes.FirstColWidth)#</option>
			</cfloop>
			</select>		
	</cfif>

		<cfif Attributes.Cmayores EQ "">
			<input name="#Attributes.Cmayor#" id="#Attributes.Cmayor#" maxlength="4" size="4"  type="text" <cfif Attributes.readOnly eq "true">readonly="yes"</cfif>
				onFocus="javascript:this.select();"
				onBlur="javascript:Cmayor_onblur#Attributes.Ccuenta#(
					this, 
					#Attributes.Ccuenta#,
					#Attributes.CFcuenta#,
					#Attributes.Cformato#,
					#Attributes.Cdescripcion#,
					#Attributes.Cmayor#_id,
					#Attributes.Cmayor#_mask
					);" 
				onChange="javascript:document.#Attributes.form#.#Evaluate('Attributes.Cformato')#.value='';"
				tabindex="#Attributes.tabindex#" 
				onkeyup="javascript:conlis_keyup_#Attributes.Ccuenta#(event);"
				onKeyPress="javascript:
						window.setTimeout('if (document.#Attributes.form#.#Attributes.Cmayor#.value.length >= 4) document.#Attributes.form#.#Attributes.Cmayor#.blur();',10); 
						if ((document.layers) ? e.which : event.keyCode == 13) return false; else return true;
					"
				value="<cfif LvarQuery.ConQuery>#LvarQuery.Cmayor#</cfif>">
			<cfset LvarCmayorSelected = true>
		<cfelse>
		<select name="#Attributes.Cmayor#" id="#Attributes.Cmayor#" tabindex="#Attributes.tabindex#" <cfif Attributes.readOnly eq true >disabled</cfif>
		>
          <cfset LvarCmayorSelected = false>
          <cfloop index="i" list="#Attributes.Cmayores#">
            <option value="#i#"<cfif LvarQuery.ConQuery AND LvarQuery.Cmayor EQ i> selected	<cfset LvarCmayorSelected = true></cfif>>#i#</option>
          </cfloop>
        </select>
		</cfif>		

			<input name="#Attributes.Cformato#" id="#Attributes.Cformato#" maxlength="#longitud-5#" size="#longitud#" type="text" <cfif Attributes.readOnly eq "true">readonly="yes"</cfif>
				style="text-transform:uppercase"
				tabindex="#Attributes.tabindex#" 
				onBlur="javascript:TraeCuentasTag#Attributes.Ccuenta#(#Attributes.form#.#Attributes.Cmayor#, this);"
				onFocus="javascript:this.select(); if (this.tabIndex != #Attributes.tabIndex#) this.tabIndex = #Attributes.tabIndex#;"
				onkeyup="javascript:conlis_keyup_#Attributes.Ccuenta#(event);"
				onKeyPress="javascript:return KeyPressCuentaFinanciera(event, #Attributes.form#.#Attributes.Ccuenta#, #Attributes.form#.#Attributes.CFcuenta#, #Attributes.form#.#Attributes.Cdescripcion#);"
				value="<cfif LvarQuery.ConQuery>#LvarQuery.CFdetalle#</cfif>"
			>		
		
			<input 	type="text" name="#Attributes.Cdescripcion#" id="#Attributes.Cdescripcion#" readonly="yes"
					maxlength="80" size="#Attributes.descwidth#" 
					tabindex="-1"
					style="border:solid 1px ##CCCCCC; background:inherit;"
			value="<cfif LvarQuery.ConQuery and LvarCmayorSelected>#LvarQuery.CFdescripcion#</cfif>">
		
			<cfif Attributes.readOnly neq "true">				
				<cfif ucase(Attributes.Conlis) EQ "S">
	  			<a href="javascript:doConlisTagCuentas#Attributes.Ccuenta#();" id = "hhref_#Attributes.Ccuenta#" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Description.gif" 
						alt="Lista de Cuentas Financieras" 
						name="imagen" 
						id = "img_#Attributes.Ccuenta#"
						width="18" height="14" 
						border="0" align="absmiddle" 
						onMouseOver="document.getElementById('#Attributes.Cformato#').disableBlur = true;"
						onMouseDown="document.getElementById('#Attributes.Cformato#').disableBlur = true;"
						onMouseUp  ="document.getElementById('#Attributes.Cformato#').disableBlur = false;"
						onMouseOut ="document.getElementById('#Attributes.Cformato#').disableBlur = false;"
					>				</a>
				</cfif>
			</cfif>	
			<input type="hidden" name="#Attributes.Ccuenta#" 	id="#Attributes.Ccuenta#" 	value="<cfif LvarQuery.ConQuery and LvarCmayorSelected>#LvarQuery.Ccuenta#</cfif>" alt="#Attributes.alt#">
			<input type="hidden" name="#Attributes.CFcuenta#" 	id="#Attributes.CFcuenta#" 	value="<cfif LvarQuery.Nuevo and LvarCmayorSelected>#LvarQuery.CFcuenta#</cfif>">
			<input type="hidden" name="#Attributes.Cmayor#_id" 	id="#Attributes.Cmayor#_id"	value="">
			<input type="hidden" name="#Attributes.Cmayor#_mask" id="#Attributes.Cmayor#_mask" value="<cfif isdefined("rsMascara") and ListLen(rsMascara.columnList) GTE 1>#rsMascara.Cmascara#</cfif>">

			<iframe name="#Attributes.frame#" id="#Attributes.frame#" scrolling="yes" src="about:blank" 
				style="display:none;"
				height="100" width="100" 
				>
			</iframe>
	</div>
	

<script language="JavaScript">
	var LvarEcodigo_#Attributes.Ccuenta# = "#LvarEcodigo#";
	function ConlisArguments#Attributes.Ccuenta#() 
	{
		var OcodigoArg = "";
		<cfif trim(Attributes.Ocodigo) NEQ "" OR trim(Attributes.CFid) NEQ "">
		OcodigoArg = fnOcodigoArg#Attributes.Ccuenta#();
		</cfif>
		return ("?form=#JSStringFormat( URLEncodedFormat( Attributes.form ))
			  #&id=#JSStringFormat( URLEncodedFormat( Attributes.Ccuenta ))
			  #&idF=#JSStringFormat( URLEncodedFormat( Attributes.CFcuenta ))
			  #&desc=#JSStringFormat( URLEncodedFormat( Attributes.Cdescripcion ))
			  #&fmt=#JSStringFormat( URLEncodedFormat( Attributes.Cformato ))
			  #&mayor=#JSStringFormat( URLEncodedFormat( Attributes.Cmayor ))
			  #&movimiento=#JSStringFormat( URLEncodedFormat( Attributes.movimiento ))
			  #&auxiliares=#JSStringFormat( URLEncodedFormat( Attributes.auxiliares ))
			  #&Ctipo=#JSStringFormat( URLEncodedFormat( Attributes.Ctipo))
			  #&Ecodigo= " + LvarEcodigo_#Attributes.Ccuenta# + "#''
			  #&Cnx=#JSStringFormat( URLEncodedFormat( Attributes.Conexion ))
			  #<cfif Attributes.cf_conceptoPago NEQ "">&cf_conceptopago=#JSStringFormat( URLEncodedFormat(Attributes.cf_conceptoPago))#</cfif><cfif Attributes.Fecha NEQ "">&fecha=#JSStringFormat( URLEncodedFormat( Attributes.fecha))#</cfif><cfif Attributes.NoVerificarPres>&NoVerificarPres=yes</cfif>" + OcodigoArg);
	}

<!--- PROCESA Attributes.Ocodigo o Attributes.CFid --->
<cfset LvarATTRIB		= "">
<cfif trim(Attributes.Ocodigo) NEQ "">
	<cfset LvarATTRIB	= "Ocodigo">
<cfelseif trim(Attributes.CFid) NEQ "">
	<cfset LvarATTRIB	= "CFid">
</cfif>
<cfif LvarATTRIB NEQ "">
	<cfif isnumeric(Attributes[LvarATTRIB])>
		<cfset LvarCAMPO_ID = "">
	<cfelse>
		<cfset LvarCAMPO_ID = "#Attributes[LvarATTRIB]#">
	</cfif>
	<cfif LvarCAMPO_ID NEQ "">
		<cfif find(",",LvarCAMPO_ID)>
			<cfset LvarCAMPO_COD = listGetAt(LvarCAMPO_ID,2)>
			<cfif NOT find(LvarCAMPO_COD,".")>
				<cfset LvarCAMPO_COD = "#Attributes.form#.#LvarCAMPO_COD#">
			</cfif>
			<cfset LvarCAMPO_ID = listGetAt(LvarCAMPO_ID,1)>
			<cfif NOT find(LvarCAMPO_ID,".")>
				<cfset LvarCAMPO_ID = "#Attributes.form#.#LvarCAMPO_ID#">
			</cfif>
		<cfelse>
			<cfif NOT find(LvarCAMPO_ID,".")>
				<cfset LvarCAMPO_ID = "#Attributes.form#.#LvarCAMPO_ID#">
			</cfif>
			<cfset LvarCAMPO_COD = LvarCAMPO_ID>
		</cfif>
		<cfset LvarCAMPO_COD_ANT = "Gvar#replace(LvarCAMPO_COD,".","_","ALL")#_anterior">
		var #LvarCAMPO_COD_ANT# = "";
	</cfif>
</cfif>
<cfif LvarATTRIB NEQ "">
	function fnOcodigoArg#Attributes.Ccuenta#()
	{
		var LvarArgument = "";
		<cfif LvarCAMPO_ID EQ "">
			LvarArgument = "&#LvarATTRIB#=#Attributes[LvarATTRIB]#";
		<cfelse>
			if (document.#LvarCAMPO_ID# && document.#LvarCAMPO_COD#)
			{
				#LvarCAMPO_COD_ANT# = document.#LvarCAMPO_COD#.value;
				if (#LvarCAMPO_COD_ANT#.replace(/\s/,"") != "")
					LvarArgument = "&#LvarATTRIB#=" + escape(document.#LvarCAMPO_ID#.value);
					
				var LvarNewEvent = 	"if (#LvarCAMPO_COD_ANT# != this.value) \ " +
									"{ \ " +
									"	document.#Attributes.form#.#Attributes.Cdescripcion#.value='** CAMBIO OFICINA **'; \ " +
									"	document.#Attributes.form#.#Attributes.Ccuenta#.value=''; \ " +
									"	document.#Attributes.form#.#Attributes.CFcuenta#.value=''; \ " +
									"	Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior = ''; \ " +
									"} \ ";

				if (document.#LvarCAMPO_COD#.onchange)
				{
					var LvarEvent = document.#LvarCAMPO_COD#.onchange.toString();
					if (LvarEvent.search("#LvarCAMPO_COD_ANT#") == -1)
						document.#LvarCAMPO_COD#.onchange = new Function(LvarNewEvent + LvarEvent.substring(LvarEvent.indexOf("{"),LvarEvent.lastIndexOf("}")+1));
				}
				else
					document.#LvarCAMPO_COD#.onchange = new Function(LvarNewEvent);
			}
		</cfif>				
		return LvarArgument;
	}
	fnOcodigoArg#Attributes.Ccuenta#();
</cfif>
	function conlis_keyup_#Attributes.Ccuenta#(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			document.getElementById('#Attributes.Cformato#').disableBlur = true;
			doConlisTagCuentas<cfoutput>#Attributes.Ccuenta#</cfoutput>();
		}
	}
	function doConlisTagCuentas#Attributes.Ccuenta#() {
		popUpWindow('/cfmx/sif/Utiles/ConlisCuentasFinancieras.cfm' +
			ConlisArguments#Attributes.Ccuenta#() 
				+ '&Cmayor='   + escape(document.#Attributes.form#.#Attributes.Cmayor#.value)
				+ '&CFdetalle=' + escape(document.#Attributes.form#.#Attributes.Cformato#.value)
			<cfif Attributes.Cmayores NEQ "">
				+ '&Cmayores=' + escape('#Attributes.Cmayores#')
			</cfif>
			,100,200,815,400);
	}
	var Gvar_CF_cuentas_#Attributes.Ccuenta# = false; 				// Control para doble mensaje;
	var Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior = ""; 	// Control cambio de valor;

	function TraeCuentasTag#Attributes.Ccuenta#(objMayor, objDetalle) {
		objDetalle.value = objDetalle.value.toUpperCase();
		if (Gvar_CF_cuentas_#Attributes.Ccuenta#) return;
		<cfif Attributes.onchange NEQ "">
		if (objMayor.value != '#LvarQuery.CMayor#' || objDetalle.value != '#LvarQuery.CFdetalle#') #Attributes.onchange#
		</cfif>
		if (objDetalle.disableBlur) {
			objDetalle.disableBlur = false;
			return;
		}
		if (trim(objMayor.value) != "" && trim(document.#Attributes.form#.#Attributes.CMayor#_mask.value)!='') {
			FormatoCuenta (document.#Attributes.form#.#Attributes.CMayor#_mask.value, objDetalle);
			Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior = "";
			if (objDetalle.value!="" && (Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior != objDetalle.value || document.#Attributes.form#.#Attributes.CFcuenta#.value != '') ) {
				Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior = objDetalle.value;
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
			if (objcformato.tabIndex != #Attributes.tabIndex#)
			{
				objcformato.tabIndex = #Attributes.tabIndex#;
				objcformato.focus();
			}
			TraeMascaraCuenta(objmayor.value, '#JSStringFormat(Attributes.frame)#',
				ConlisArguments#Attributes.Ccuenta#());
			Gvar_CF_cuentas_#Attributes.Ccuenta#_valorAnterior = '';
		}
	}

</script>
</cfoutput>