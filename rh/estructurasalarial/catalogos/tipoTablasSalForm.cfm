<cfif isdefined("Url.RHTTid") and not isdefined("form.RHTTid")><cfset form.RHTTid = url.RHTTid></cfif>
		<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
		<cfset MODO = "ALTA">
		<cfif isdefined("Form.RHTTid") and form.RHTTid GT 0>
			<cfset MODO = "CAMBIO">
		</cfif>
		<cfif (MODO neq "ALTA")>
			<cf_translatedata name="validar" tabla="RHTTablaSalarial" col="RHTTdescripcion" filtro="RHTTid = #Form.RHTTid#"/>
			<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
			<cfquery name="rsRHTTablaSalarial" datasource="#session.dsn#">
				select RHTTid, RHTTcodigo, #LvarRHTTdescripcion# as RHTTdescripcion, ts_rversion
				from RHTTablaSalarial
				where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
			<cfset ts = "">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsRHTTablaSalarial.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<form action="tipoTablasSalSQL.cfm" method="post" name="form1">
			<input name="SEL" type="hidden" value="1" />
            <cfif (MODO neq "ALTA")><input name="ts_rversion" type="hidden" value="<cfoutput>#ts#</cfoutput>" /></cfif>
            <cfif isdefined("form.PAGENUM")><input name="PAGENUM" type="hidden" value="<cfoutput>#form.PAGENUM#</cfoutput>" /></cfif>
			<input name="modo" type="hidden" value="" />
			<input name="RHTTid" type="hidden" value="<cfif isdefined('form.RHTTid')><cfoutput>#form.RHTTid#</cfoutput></cfif>" />
			<table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td>&nbsp;</td></tr>
			  <tr>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td align="right"><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate>:</strong>&nbsp;</td>
						<td><input name="RHTTcodigo" type="text" id="RHTTcodigo" size="5" maxlength="5" value="<cfif (MODO neq "ALTA")><cfoutput>#rsRHTTablaSalarial.RHTTcodigo#</cfoutput></cfif>"></td>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right"><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</strong>&nbsp;</td>
						<td><input name="RHTTdescripcion" type="text" id="RHTTdescripcion" <cfif (MODO neq "ALTA")>value="<cfoutput>#HTMLEditFormat(rsRHTTablaSalarial.RHTTdescripcion)#</cfoutput>"</cfif> size="80" maxlength="80"></td>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td>
				<cfif modo EQ "ALTA">
					<cf_botones values="Limpiar, Agregar" names="Limpiar,Alta" nbspbefore="4" nbspafter="4" tabindex="3">
				<cfelse>	
					<cf_botones values="Eliminar,Modificar,Siguiente" names="Baja,Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
					<input name="ts_rversion" type="hidden" value="<cfoutput>#ts#</cfoutput>"/>
				</cfif>
				</td>
			  </tr>
			</table>
		</form>
		<script language="javascript" type="text/javascript">
			<!--// 
			// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// Qforms. carga todas las librerías por defecto
			qFormAPI.include("*");
			//inicializa qforms en la página
			qFormAPI.errorColor = "#FFFFCC";
			//crea el objeto qforms
			objForm = new qForm("form1");
			//asigna las validaciones
			objForm.RHTTcodigo.description = "<cfoutput>#JSStringFormat('Código')#</cfoutput>";
			objForm.RHTTdescripcion.description = "<cfoutput>#JSStringFormat('Descripción')#</cfoutput>";
			objForm.RHTTcodigo.required = true;
			objForm.RHTTdescripcion.required = true;
			objForm.RHTTcodigo.obj.focus();
			//funciones llamadas por objetos del form
			function funcVigencias(){
				if (!objForm.RHTTid || objForm.RHTTid.getValue()==''){
					alert("<cfoutput>#JSStringFormat('Debe seleccionar una Tabla Salarial, para poder dar mantenimiento a sus vigencias.')#</cfoutput>");
					return false;
				}
				deshabilitarValidacion();
				objForm.obj.action = "vigenciasTablasSal.cfm";
				return true;
			}
			function habilitarValidacion(){
				objForm.RHTTcodigo.required = true;
				objForm.RHTTdescripcion.required = true;
			}
			function deshabilitarValidacion(){
				objForm.RHTTcodigo.required = false;
				objForm.RHTTdescripcion.required = false;
			}
			//-->
			
			function funcSiguiente(){
				document.form1.SEL.value = "2";
				document.form1.RHTTid.value = "<cfoutput>#form.RHTTid#</cfoutput>";
				document.form1.modo.value = "<cfoutput>#form.modo#</cfoutput>";
				document.form1.action = "tipoTablasSal.cfm";
				return true;
			}
			
</script>
