<cf_template>
<cf_templatearea name="title">
	Familiares
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navegacion=ListToArray('index.cfm,Registro de Personas;sa_personas.cfm?id_persona=#URLEncodedFormat(url.id_persona)#,Datos Personales;javascript:void(0),Familiares',';')>
	<cfinclude template="../../pNavegacion.cfm">

<cfparam name="url.id_persona" type="numeric">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="lista">
	select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#"> as id_persona,
		fam.id_persona as pariente, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid, fam.Psexo
	from sa_personas fam
	where fam.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and fam.id_persona != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
	  and not exists (
	  	select *
		from sa_pariente pte
		where pte.sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
		  and pte.pariente = fam.id_persona )
	<cfif IsDefined('url.filtro_Pnombre') and Len(Trim(url.filtro_Pnombre))>
	  and upper(fam.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Pnombre))#%">
	</cfif>
	<cfif IsDefined('url.filtro_Papellido1') and Len(Trim(url.filtro_Papellido1))>
	  and upper(fam.Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Papellido1))#%">
	</cfif>
	<cfif IsDefined('url.filtro_Papellido2') and Len(Trim(url.filtro_Papellido2))>
	  and upper(fam.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Papellido2))#%">
	</cfif>
	<cfif IsDefined('url.filtro_Pid') and Len(Trim(url.filtro_Pid))>
	  and upper(fam.Pid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.filtro_Pid))#%">
	</cfif>
	order by fam.Papellido1
</cfquery>


<cfoutput>
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='familiares.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
	//-->
	</script>
			<table width="610" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Registro de familiares</td>
			  </tr>
				<tr><td width="140" valign="top">Nombre
				</td>
				  <td valign="top">#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#</td>
			      <td colspan="2" rowspan="5" valign="top">
				    <cfinvoke component="sif.Componentes.DButils"
					  method="toTimeStamp"
					  returnvariable="tsurl"
					  arTimeStamp="#data.ts_rversion#"/> 
					  <a href="sa_personas.cfm?id_persona=#URLEncodedFormat(data.id_persona)#&amp;push=yes">
					  <img src="imagen_persona.cfm?id_persona=#data.id_persona#&ts=#tsurl#" height="100" border="0" 
					  alt="#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#"></a>
				  </td>
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
			      <td colspan="4" align="left">
				  
				  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Papellido1,Papellido2,Pnombre,Pid"
			etiquetas="Apellido Paterno,Materno,Nombre,C&eacute;dula"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ira="familiares3.cfm"
			form_method="get"
			keys="id_persona,pariente"
			mostrar_filtro="yes"
			botones="Regresar"
		/>		&nbsp;</td>
			    </tr>
	  </table> 


</cfoutput>	

</cf_templatearea>
</cf_template>

