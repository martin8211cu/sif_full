<cfif isdefined("Form.id_valor")>
	<cfset Form.id_valor = Form.id_valor>
</cfif>
<cfif isdefined("Form.id_valor")>
	<cfset Form.id_valor2 = Form.id_valor>
</cfif>
<cfif isdefined("Form.id_atrib")>
	<cfset Form.id_atrib = Form.id_atrib>
	<cfset Form.id_tipo = Form.id_atrib>
</cfif>

<!--- TOMA LAS VARIABLES REQUERIDAS DE LA URL CUANDO VIENE DE HACER CLIC EN EL BOTON FILTRAR --->
<cfif isdefined("Url.id_tipo") and len(trim(Url.id_tipo))>
	<cfif not isdefined("Form.id_tipo")>
		<cfset Form.id_tipo = Url.id_tipo>
	<cfelseif isdefined("Form.id_tipo") and len(trim(Form.id_tipo)) eq 0>
		<cfset Form.id_tipo = Url.id_tipo>
	</cfif>	
</cfif>
<cfif isdefined("Url.id_valor") and len(trim(Url.id_valor))>
	<cfif not isdefined("Form.id_valor")>
		<cfset Form.id_valor = Url.id_valor>
	<cfelseif isdefined("Form.id_valor") and len(trim(Form.id_valor)) eq 0>
		<cfset Form.id_valor = Url.id_valor>
	</cfif>	
</cfif>

<cfif isdefined("Url.nombre") and len(trim(Url.nombre))>
	<cfif not isdefined("Form.nombre")>
		<cfset Form.nombre = Url.nombre>
	<cfelseif isdefined("Form.nombre") and len(trim(Form.nombre)) eq 0>
		<cfset Form.nombre = Url.nombre>
	</cfif>
</cfif>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>	
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->				
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
	<cfset form.MTcodigo = 0>
</cfif>					
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
<cfif isdefined("url.Filtro_contenido2") and len(trim(url.Filtro_contenido2))>
	<cfset form.Filtro_contenido2 = url.Filtro_contenido2>
</cfif>
<cfif isdefined("url.Filtro_orden_val") and len(trim(url.Filtro_orden_val))>
	<cfset form.Filtro_orden_val = url.Filtro_orden_val>
</cfif>
<cfparam name="form.Pagina" default="1">					
<cfparam name="form.Filtro_contenido2" default="">
<cfparam name="form.Filtro_orden_val" default="">
<cfif len(trim(form.Pagina)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina = 1>
</cfif>

<!--- DEFINE EL MODO --->
<cfset modo="ALTA">
<cfif isdefined("Form.id_valor") and len(trim(Form.id_valor))>
	<cfset modo="CAMBIO">
</cfif>
	
<!--- CONSULTAS --->	
<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor") >
	<!--- 1. Form --->	
	<cfquery datasource="#Session.Edu.DSN#" name="rsMAValorAtributo">
		select convert(varchar,b.id_atributo) as  id_atributo,  substring(contenido,1,35) as contenido, orden_valor 
		from MAValorAtributo a, MAAtributo b
		where  b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
		  and a.id_atributo = b.id_atributo 
			<cfif isdefined("Form.id_valor") AND Form.id_valor NEQ "" >
			  and a.id_valor =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_valor#">
			</cfif>
			<cfif isdefined("Form.id_atrib") AND Form.id_atrib NEQ "" >
			  and a.id_atributo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_atrib#">
			</cfif>
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMAAtributoDocumento">
		<!--- Existen dependencias con MAAtributoDocumento--->
		select isnull(1,0) from MAAtributoDocumento a, MAValorAtributo b
		where a.id_atributo= <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
		  <cfif isdefined("Form.id_valor") AND Form.id_valor NEQ "" >
			and b.id_valor= <cfqueryparam value="#form.id_valor#" cfsqltype="cf_sql_numeric">
		  </cfif>
		  and a.id_valor = b.id_valor 
	</cfquery> 
</cfif>

<!--- INTERFASE --->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr align="center" class="subTitulo"> 
      <td colspan="6" style="font-weight: bold"> 
	  	<strong><cfoutput>Nombre del Atributo: #Form.nombre#</cfoutput></strong>
	  </td>
    </tr>
	<tr> 
      <td width="50%" valign="top"> 
		 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td>
					 <form name="lista" method="post" action="ConlisValores.cfm">
						<cfoutput> 
							<!--- CAMPOS OCULTOS DE LA PAGINA Y DE LOS FILTROS PARA SER ENVIADOS AL FORM Y AL SQL --->
							<input name="pagina" id="pagina" value="#Form.pagina#" type="hidden" />
							<input name="nombre" id="nombre" value="#Form.nombre#" type="hidden" />
							<cfif isdefined("Form.id_tipo")  >
								<input name="id_tipo" id="id_tipo" value="#Form.id_tipo#" type="hidden" />
							<cfelseif isdefined("Form.id_atrib")>
								<input name="id_tipo22" id="id_tipo2" value="#Form.id_atrib#" type="hidden" />
							</cfif>
							<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor")>
								<input type="hidden" name="HayMAAtributoDocumento" value="<cfif #rsHayMAAtributoDocumento.recordCount# GT 0>#rsHayMAAtributoDocumento.recordCount#<cfelse>0</cfif>" />
							</cfif>
							<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor")>
								<input name="id_valor2" id="id_valor2" value="#Form.id_valor#" type="hidden" />
							</cfif>
						</cfoutput>
						<!---PARAMETROS QUE SE ENVIAN POR LA URL AL HACER CLIC EN FILTRAR --->
						<cfset params = "nombre="& Form.nombre>
						<cfif isdefined("Form.id_tipo") and len(trim(Form.id_tipo))>
							<cfset params = params & "&id_tipo="& Form.id_tipo>
						<cfelseif isdefined("Form.id_atrib") and len(trim(Form.id_tipo))>
							<cfset params = params & "&id_atrib="& Form.id_atrib>
						</cfif>
						<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor") and len(trim(Form.id_valor))>
							<cfif #rsHayMAAtributoDocumento.recordCount# GT 0>
								<cfset params = params & "&HayMAAtributoDocumento=" & rsHayMAAtributoDocumento.recordCount>
							<cfelse>
								<cfset params = params & "&HayMAAtributoDocumento=0">
							</cfif>
						</cfif>
						<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor") and len(trim(Form.id_valor))>
							<cfset params = params & "&id_valor=" & Form.id_valor>
						</cfif>
						<!--- NAVEGACION --->
						<cfset nav = "">
						<cfset nav = nav & "pagina="&form.pagina & "&Filtro_contenido2="&form.Filtro_contenido2& "&Filtro_orden_val="&form.Filtro_orden_val>
						<cfif isdefined("form.id_tipo") and len(trim(form.id_tipo))>
							<cfset nav = nav & "&id_tipo="&form.id_tipo>
						</cfif>
						<cfif isdefined("form.nombre") and len(trim(form.nombre))>
							<cfset nav = nav & "&nombre="&form.nombre>
						</cfif>
						<!--- LISTA --->
						<cfinvoke 
							 component="edu.Componentes.pListas"
							 method="pListaEdu"
							 returnvariable="pListaPlanEvalDet">
								  <cfinvokeargument name="tabla" value="MAValorAtributo a,  MAAtributo b"/>
								  <cfinvokeargument name="columnas" value=" convert(varchar,a.id_valor) as id_valor, convert(varchar,a.id_atributo) as id_atrib, substring(a.contenido,1,35) as contenido2, a.orden_valor as orden_val"/><!--- #params# --->
								  <cfinvokeargument name="desplegar" value="contenido2, orden_val"/>
								  <cfinvokeargument name="etiquetas" value="Contenido, Orden"/>
								  <cfinvokeargument name="filtro" value=" b.CEcodigo = #Session.Edu.CEcodigo# and a.id_atributo = #form.id_tipo# and a.id_atributo = b.id_atributo order by a.orden_valor, a.contenido"/>
								  <cfinvokeargument name="align" value="left,right"/>
								  <cfinvokeargument name="ajustar" value="N"/>
								  <cfinvokeargument name="maxRows" value="3"/>
								  <cfinvokeargument name="irA" value="ConlisValores.cfm"/>
								  <cfinvokeargument name="incluyeForm" value="false"/>
								  <cfinvokeargument name="formName" value="lista"/>
								  <cfinvokeargument name="conexion" value="#session.Edu.DSN#"/>
								  <cfinvokeargument name="keys" value="id_valor"/>
								  <cfinvokeargument name="formatos" value="S,I"/>
								  <cfinvokeargument name="mostrar_filtro" value="true"/>
								  <cfinvokeargument name="filtrar_automatico" value="true"/>
								  <cfinvokeargument name="filtrar_por" value="a.contenido,a.orden_valor"/>
								  <cfinvokeargument name="navegacion" value="#nav#"/>
						</cfinvoke>
					</form> 
					<script language="javascript" type="text/javascript">
						function funcFiltrar(){
							document.lista.action = "ConlisValores.cfm<cfoutput>?#params#</cfoutput>";
							return true;
						}
					</script>
				</td></tr>
			</table>
	  </td>
      <td width="50%" valign="top"> 
		 	<form name="form1" method="post" action="SQLConlisValores.cfm">
				<cfoutput> 
					<!--- CAMPOS OCULTOS DE LA PAGINA Y DE LOS FILTROS PARA SER ENVIADOS AL FORM Y AL SQL --->
					<input name="pagina" id="pagina" value="#Form.pagina#" type="hidden" />
					<input name="Filtro_contenido2" id="Filtro_contenido2" value="#Form.Filtro_contenido2#" type="hidden" />
					<input name="Filtro_orden_val" id="Filtro_orden_val" value="#Form.Filtro_orden_val#" type="hidden" />
					
					<!--- CAMPOS OCULTOS DE LAS LLAVES PARA SER ENVIADOS AL FORM Y AL SQL --->
					<input name="nombre" id="nombre" value="#Form.nombre#" type="hidden" />
					<cfif isdefined("Form.id_tipo")  >
						<input name="id_tipo2" id="id_tipo2" value="#Form.id_tipo#" type="hidden" />
					<cfelseif isdefined("Form.id_atrib")>
						<input name="id_tipo22" id="id_tipo2" value="#Form.id_atrib#" type="hidden" />
					</cfif>
					<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor")>
						<input type="hidden" name="HayMAAtributoDocumento" value="<cfif #rsHayMAAtributoDocumento.recordCount# GT 0>#rsHayMAAtributoDocumento.recordCount#<cfelse>0</cfif>" />
					</cfif>
					<cfif modo NEQ 'ALTA' and isdefined("Form.id_valor")>
						<input name="id_valor2" id="id_valor2" value="#Form.id_valor#" type="hidden" />
					</cfif>
				</cfoutput> 
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr class="tituloAlterno">
						<td colspan="2">
						<cfif modo EQ 'ALTA'>Agregar <cfelse> Modificar</cfif> Valor 	
						</td>
					</tr>
					<tr>
					  <td width="15%" align="right" nowrap>Contenido &nbsp </td>
					  <td> <input name="contenido" type="text" id="contenido" tabindex="1" size="30" maxlength="80" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsMAValorAtributo.contenido#</cfoutput></cfif>" /></td>
					</tr>
					<tr> 
					  <td align="right" nowrap>Orden &nbsp </td>
					  <td nowrap> 
						<cfoutput> 
						  <input name="orden_valor" align="left" tabindex="1" type="text" id="orden_valor" size="8" maxlength="8" value="<cfif modo NEQ "ALTA">#rsMAValorAtributo.orden_valor#</cfif>" onfocus="this.value=qf(this); this.select();" onblur="fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" />
						</cfoutput> 
					   </td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr> 
					  <td colspan="2" align="center"> 
						<cf_botones modo="#modo#" include="Salir" nameEnc="Tipo" generoEnc="M" tabindex="3">
					  </td>
					</tr>
				</table>
			</form>
		</td>
    </tr>
  </table>


<script language="javascript" type="text/javascript">
	function funcSalir() {
		window.close();
		return false;
	}
</script>

<script language="JavaScript1.4" type="text/javascript" src="../../js/utilesMonto.js" >//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>	

<script language="JavaScript">
	function deshabilitarValidacion() {
		objForm.contenido.required = false;
	}
	
	function habilitarValidacion() {
		objForm.contenido.required = true;
		objForm.contenido.description = "Contenido";
	}	
	
	
	function __isValida() {
		if(btnSelected("btnBorrar")) {
			//Rodolfo Jimenez Jara, 22/04/2003, SOIN Central America.
			// Valida que la Tabla de MAValorAtributo tenga dependencias con otros.
			var msg = "";
			//alert(new Number(this.obj.form.HayMADocumento.value)); 
			if (new Number(this.obj.form.HayMAAtributoDocumento.value) > 0) {
				msg = msg + " Documentos "
			}
			//alert(new Number(this.obj.form.HayHorarioAplica.value)); 
			/*if (new Number(this.obj.form.HayHorarioAplica.value) > 0) {
				msg = msg + " horarios "
			}*/
			if (msg != "")
			{
				this.error = "Usted no puede eliminar el atributo '" + this.obj.form.contenido.value + "' porque éste tiene asociado: " + msg + ".";
				//this.obj.form.contenido.focus();
			}
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValida", __isValida);
	
	objForm = new qForm("form1");
				
	objForm.contenido.validateValida();
	
	<cfif modo EQ "ALTA">
		objForm.contenido.required = true;
		objForm.contenido.description = "Contenido";	
	<cfelseif modo EQ "CAMBIO">
		objForm.contenido.required = true;
		objForm.contenido.description = "Contenido";	
	<cfelse>
		objForm.contenido.required = false;
	</cfif>	

</script>
</body>
</html>