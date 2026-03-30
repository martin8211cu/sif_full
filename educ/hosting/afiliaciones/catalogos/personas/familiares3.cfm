<cf_template>
<cf_templatearea name="title">
	Familiares
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navegacion=ListToArray('index.cfm,Registro de Personas;sa_personas.cfm?id_persona=#URLEncodedFormat(url.id_persona)#,Datos Personales;javascript:void(0),Familiares',';')>
	<cfinclude template="../../pNavegacion.cfm">

<cfparam name="url.id_persona" type="numeric">
<cfparam name="url.pariente" type="numeric">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="pariente">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pariente#" null="#Len(url.pariente) Is 0#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="parentescos">
	select id_parentesco, 
		<cfif pariente.Psexo is 'F'>
			nombre_fem  as nombre_parentesco, upper(nombre_fem ) as nombre_upper
		<cfelse>
			nombre_masc as nombre_parentesco, upper(nombre_masc) as nombre_upper
		</cfif>
	from  sa_parentesco
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by nombre_upper
</cfquery>

<cfoutput>
	<script type="text/javascript" src="personas.js"></script>
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='familiares.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
	//-->
	</script>
	<form method="post" name="form1" id="form1" action="familiares-add.cfm" >
	<input type="hidden" name="id_persona" value="#HTMLEditFormat(url.id_persona)#">
	<input type="hidden" name="pariente" value="#HTMLEditFormat(url.pariente)#">
	<input type="hidden" name="Pnombre" value="-">
	<input type="hidden" name="Papellido1" value="-">
	<input type="hidden" name="Papellido2" value="-">
	<input type="hidden" name="Pid" value="-">
	<input type="hidden" name="foto" value="">
			<table width="610" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Registro de familiares</td>
			  </tr>
				<tr><td width="140" valign="top">Nombre
				</td>
				  <td valign="top">#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#</td>
			      <td colspan="2" rowspan="5" valign="top"><cfinvoke component="sif.Componentes.DButils"
					  method="toTimeStamp"
					  returnvariable="tsurl"
					  arTimeStamp="#data.ts_rversion#"/>
			        
                    <a href="sa_personas.cfm?id_persona=#URLEncodedFormat(data.id_persona)#&amp;push=yes"> <img src="imagen_persona.cfm?id_persona=#data.id_persona#&ts=#tsurl#" height="100" border="0" 
					  alt="#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#"></a></td>
		        </tr>
				<tr>
				  <td valign="top">Correo Electr&oacute;nico </td>
				  <td valign="top">#HTMLEditFormat(data.Pemail1)#                  </td>
		      </tr>
				<tr><td valign="top">C&eacute;dula</td>
				  <td valign="top">#HTMLEditFormat(data.Pid)#</td>
		        </tr>
			    <tr>
			      <td align="left">&nbsp;</td>
			      <td align="left">&nbsp;</td>
		      </tr>
			    <tr>
			      <td align="left">&nbsp;</td>
		          <td align="left">&nbsp;</td>
	          </tr>
			    <tr>
                  <td colspan="4" align="left" class="subTitulo">Seleccione un  familiar adicional </td>
		      </tr>
			    <tr>
			      <td valign="top">Nombre </td>
			      <td width="257" valign="top">#HTMLEditFormat(pariente.Pnombre)# #HTMLEditFormat(pariente.Papellido1)# #HTMLEditFormat(pariente.Papellido2)#</td>
		          <td colspan="2" rowspan="6" valign="top">
				   <cfinvoke component="sif.Componentes.DButils"
											  method="toTimeStamp"
											  returnvariable="tsurl"
											  arTimeStamp="#pariente.ts_rversion#"/> 
				<a href="sa_personas.cfm?id_persona=#URLEncodedFormat(pariente.id_persona)#&amp;push=yes"><img src="imagen_persona.cfm?id_persona=#pariente.id_persona#&ts=#tsurl#" height="100" border="0" alt="#HTMLEditFormat(pariente.Pnombre)# #HTMLEditFormat(pariente.Papellido1)# #HTMLEditFormat(pariente.Papellido2)#"></a></td>
	          </tr>
			    <tr>
                  <td valign="top">Correo Electr&oacute;nico </td>
                  <td valign="top">#HTMLEditFormat(pariente.Pemail1)# </td>
	          </tr>
			    <tr>
			      <td valign="top">C&eacute;dula</td>
			      <td valign="top">#HTMLEditFormat(pariente.Pid)#</td>
	          </tr>
			    <tr>
			      <td align="left">Parentesco
				  </td>
			      <td align="left"><select name="parentesco" id="parentesco">
                    <option value="">&nbsp;</option>
                    <cfloop query="parentescos">
                      <option value="NEL,#parentescos.id_parentesco#"> #HTMLEditFormat(parentescos.nombre_parentesco)#</option>
                    </cfloop>
                  </select></td>
		        </tr>
			    <tr>
			      <td align="left"></td>
			      <td align="left"><input type="submit" value="Agregar"></td>
		      </tr>
			    <tr>
			      <td align="left"></td>
			      <td align="left"></td>
		      </tr>
	  </table> 
</form>

</cfoutput>	

</cf_templatearea>
</cf_template>

