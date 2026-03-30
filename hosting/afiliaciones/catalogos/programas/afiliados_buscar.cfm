<cf_template>
<cf_templatearea name="title">
	Afiliaci&oacute;n a programas
</cf_templatearea>
<cf_templatearea name="body">

<cfparam name="session.id_programa_srch" default="">
<cfparam name="session.id_vigencia_srch" default="">
<cfparam name="url.id_programa" default="#session.id_programa_srch#">
<cfparam name="url.id_vigencia" default="#session.id_vigencia_srch#">
<cfset session.id_programa_srch = url.id_programa>
<cfset session.id_vigencia_srch = url.id_vigencia>

<cfparam name="url.id_persona" default="">


<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.periodicidad, v.tipo_periodo,
		v.fecha_desde, v.fecha_hasta, v.cantidad_carnes, v.generar_carnes
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_programa#">
	  and v.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vigencia#">
</cfquery>


<cfquery datasource="#session.dsn#" name="lista">
	select 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" > as id_programa,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#" > as id_vigencia,
		fam.id_persona, fam.Pnombre, fam.Papellido1, fam.Papellido2, fam.Pid, fam.Psexo
	from sa_personas fam
	where fam.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and not exists (
	  	select *
		from sa_afiliaciones pte
		where pte.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#" >
		  and pte.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#" >
		  and pte.id_persona = fam.id_persona )
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

	<cfset navegacion=ListToArray('index.cfm,Registro de Programas;sa_programas.cfm?id_programa=#URLEncodedFormat(url.id_programa)#,#progs.nombre_programa#;sa_vigencia.cfm?id_programa=#URLEncodedFormat(url.id_programa)#&id_vigencia=#URLEncodedFormat(url.id_vigencia)#,#progs.nombre_vigencia#;javascript:void(0),Afiliación',';')>
	<cfinclude template="../../pNavegacion.cfm">


<cfoutput>
	
	<script type="text/javascript" src="../personas/personas.js"></script>
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_vigencia.cfm?id_programa=#JSStringFormat(URLEncodedFormat(url.id_programa))#&id_vigencia=#JSStringFormat(URLEncodedFormat(url.id_vigencia))#';
		}
		function validar(obj){
			return true;
		}
	//-->
	</script>
	
			<table width="559" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="4" class="subTitulo">
			Afiliar a un Programa </td>
			  </tr>
				<tr>
				  <td width="140" align="left" nowrap>Programa</td>
				  <td width="391" colspan="3" valign="top">#progs.nombre_programa# #progs.nombre_vigencia#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Periodo</td>
				  <td colspan="3" valign="top">#DateFormat(progs.fecha_desde,'dd/mm/yyyy')# - #DateFormat(progs.fecha_hasta,'dd/mm/yyyy')#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Costo</td>
				  <td colspan="3" valign="top">#NumberFormat(progs.costo,',0.00')#                      <cfif progs.tipo_periodo is 'U'>
    Pago &Uacute;nico
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Semana
        <cfelse>
      Cada #progs.periodicidad# Semanas
    </cfif>
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Mes
        <cfelse>
      Cada #progs.periodicidad# Meses
    </cfif>
</cfif>				  </td>
</tr>
                <tr>
                  <td align="left">Carn&eacute;s / Entradas </td>
                  <td colspan="3" align="left">
				  <cfif progs.generar_carnes>
				  #progs.cantidad_carnes#
				  <cfelse>No se utilizan
				  </cfif></td>
                </tr><cfif progs.generar_carnes and progs.cantidad_carnes>
                  <tr>
                    <td colspan="4" class="subTitulo">Seleccione el nuevo afiliado </td>
                  </tr>
                  <tr>
                    <td colspan="4" class="subTitulo">  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Papellido1,Papellido2,Pnombre,Pid"
			etiquetas="Apellido Paterno,Materno,Nombre,C&eacute;dula"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ira="afiliados_carnet.cfm"
			form_method="get"
			keys="id_programa,id_vigencia,id_persona"
			mostrar_filtro="yes"
			botones="Regresar" />		</td>
                  </tr>
				
				</cfif>


<tr><td colspan="4" class="formButtons">
</td></tr>
</table>
</cfoutput>	
	<script type="text/javascript">
	<!--
		document.form1.pariente = document.form1.id_persona;
	//-->
	</script>


</cf_templatearea>
</cf_template>


