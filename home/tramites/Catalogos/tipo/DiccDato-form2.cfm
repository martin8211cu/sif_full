<html>
<head>
	<cf_templatecss>
</head>

<body>
	<cfinclude template="DiccDato-config.cfm">

	<cfset modoDet = "ALTA">
	<cfif isdefined("Form.id_valor")>
		<cfset modoDet = "CAMBIO">
		
		<cfquery name="rsValor" datasource="#session.tramites.dsn#">
			select	a.id_tipo,
					a.id_valor,
					a.valor
			from DDValor a
			where a.id_valor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_valor#">
			and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		</cfquery>

	</cfif>
	
	<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		select	a.id_tipo,
				a.id_valor,
				a.valor
		from DDValor a
		where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		order by a.valor
	</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<cfif modoDet EQ "CAMBIO">
		<cfoutput>
		function funcBaja() {
			if (confirm('Esta seguro de que desea eliminar el valor #rsValor.valor# de la lista de valores del tipo de dato #rsTipoDato.nombre_tipo#?')) {
				return true;
			} else {
				return false;
			}
		}

		function funcNuevo() {
			location.href = '#CurrentPage#?id_tipo=#Form.id_tipo#'; 
			return false;
		}
		</cfoutput>
	</cfif>
</script>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="50%" valign="top">
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
				  <tr>
					<td class="tituloListas" style="padding-left: 20px; ">
						Valor
					</td>
				  </tr>
				</table>
				<div style="height: 260; width: 100%; overflow: auto;">
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="valor"/>
						<cfinvokeargument name="etiquetas" value=" "/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value=""/>
						<cfinvokeargument name="formName" value="lista"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="irA" value="#CurrentPage#"/>
						<cfinvokeargument name="keys" value="id_tipo, id_valor"/>
						<cfinvokeargument name="maxRows" value="0"/>
					</cfinvoke> 
				</div>
			</td>
			<td width="50%" valign="top">
				<form name="form1" method="post" action="DiccDato-sql-form2.cfm">
					<input type="hidden" name="id_tipo" value="<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>#Form.id_tipo#</cfif>">
					<input type="hidden" name="id_valor" value="<cfif isdefined("Form.id_valor") and Len(Trim(Form.id_valor))>#Form.id_valor#</cfif>">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
					  <tr>
						<td bgcolor="##ECE9D8" align="center" class="tituloIndicacion">
							<strong><cfif modoDet EQ "ALTA">Agregar<cfelse>Modificar</cfif> Valor</strong>
						</td>
					  </tr>
					  <tr>
					    <td>&nbsp;</td>
				      </tr>
					</table>
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td class="fileLabel" align="right" nowrap>Valor:</td>
						<td>
							<input type="text" name="valor" size="40" maxlength="60" value="<cfif modoDet EQ "CAMBIO">#HtmlEditFormat(rsValor.valor)#</cfif>">
						</td>
					  </tr>
					  <tr>
					    <td colspan="2">&nbsp;</td>
				      </tr>
					  <tr>
					    <td colspan="2" align="center">
							<cf_botones modo="#modoDet#">
						</td>
				      </tr>
					</table>
				</form>
			
			</td>
		</tr>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.valor.description = "Valor";
	objForm.valor.required = true;
	
</script>
	
</body>
</html>
