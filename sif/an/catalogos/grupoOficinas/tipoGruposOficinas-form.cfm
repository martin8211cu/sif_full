<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Tipo de Grupos de Oficina" 
returnvariable="LB_Titulo" xmlfile="tipoGruposOficinas-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGenerales" 	default="Datos Generales" 
returnvariable="LB_DatosGenerales" xmlfile="tipoGruposOficinas-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="tipoGruposOficinas-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="tipoGruposOficinas-form.xml"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Salir" 	default="Salir" 
returnvariable="BTN_Salir" xmlfile="tipoGruposOficinas-form.xml"/>

<cf_templateheader title="#LB_Titulo#">
<cf_web_portlet_start titulo="#LB_Titulo#">

<cfinclude template="/home/menu/pNavegacion.cfm">

<cfif isdefined('url.GOTid') and not isdefined('form.GOTid')>
	<cfparam name="form.GOTid" default="#url.GOTid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GOTid') and len(trim(form.GOTid))>
	<cfset modo = 'CAMBIO'>
</cfif>
<!--- 
<cfdump  label="Url" var="#url#">
<cfdump label="form"  var="#form#">
<cfdump label="modo"  var="#modo#">
<cfabort> --->
 
<style type="text/css">

<!--
.topmenu,.topmenu a {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color:#000000 }
.topmenusel,.topmenusel a {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight:bold;
 font-size: 12px; background-color:#3366CC; color:white}
-->
</style>
<cfif not isdefined("url.tab")>
 <cfparam name="url.tab" default="1">
</cfif>

<cfif isdefined('url.GOTid') and not isdefined('form.GOTid')>
	<cfparam name="form.GOTid" default="#url.GOTid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GOTid') and len(trim(form.GOTid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select GOTid, GOTcodigo, GOTnombre,ts_rversion
		from AnexoGOTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif IsDefined("form.GOTid")>
		and  GOTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GOTid#">
		</cfif>
	</cfquery>
	
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="tipoGruposOficinas-sql.cfm">
	
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
        	<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">
      	</cfif>
		<tr><td colspan="2" align="center" class="tituloListas" >#LB_DatosGenerales#</td></tr>
		<tr>
			<td align="right"><strong>#LB_Codigo#</strong></td>
        	<td>
				<input type="text" name="GOTcodigo" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#data.GOTcodigo#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>#LB_Nombre#</strong></td>
        	<td >
				<input type="text" name="GOTnombre" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#data.GOTnombre#</cfif>">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO' include="#BTN_Salir#">
					<input type="hidden" name="GOTid" value="#data.GOTid#">
					
				<cfelse>
					<cf_botones modo='ALTA' include="#BTN_Salir#">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion_GOfi" value="#ts#">
	</cfif>
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
		objForm.GOTcodigo.required = true;
		objForm.GOTcodigo.description = "Codigo";
		objForm.GOTnombre.required = true;
		objForm.GOTnombre.description = "Nombre";
	//-->
</script>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcSalir ()
	{
		objForm.GOTcodigo.required = false;
		objForm.GOTnombre.required = false
	}	
</script>

<cfif MODO EQ "CAMBIO">
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select g.GOcodigo, g.GOnombre, o.Oficodigo, o.Odescripcion,  
			(
				select count(1)
				  from AnexoGOficinaDet d
					inner join AnexoGOficina g
						on g.GOid = d.GOid
				 where g.Ecodigo	= o.Ecodigo
				   and g.GOTid		= #form.GOTid#
				   and d.Ocodigo	= o.Ocodigo
			) as cantidad
		  from Oficinas o
			left join AnexoGOficinaDet d
					inner join AnexoGOficina g
						on g.GOid = d.GOid
					on g.Ecodigo	= o.Ecodigo
				   and g.GOTid		= #form.GOTid#
				   and d.Ocodigo	= o.Ocodigo
		 where o.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="rsGrupos" datasource="#Session.DSN#">
		select g.GOcodigo, g.GOnombre,
				(select Count(b.GOid)
				from AnexoGOficinaDet b
				where b.GOid = g.GOid)
				as oficinasCount
		  from AnexoGOficina g
		 where g.Ecodigo	= #session.Ecodigo#
		   and g.GOTid		= #form.GOTid#
	</cfquery>
	<cfquery name="rsOfiOK" dbtype="query">
		select 'GRUPO: ' || GOcodigo || '-' || GOnombre as GRUPO, Oficodigo, Odescripcion, cantidad
		  from rsOficinas
		 where cantidad = 1
		 order by Grupo, Oficodigo
	</cfquery>
	<cfquery name="rsOfiNULL" dbtype="query">
		select 'OFICINAS NO ASIGNADAS A NINGUN GRUPO' as GRUPO, Oficodigo, Odescripcion, cantidad
		  from rsOficinas
		 where cantidad = 0
		 order by Grupo, Oficodigo
	</cfquery>
	<cfquery name="rsOfiERR" dbtype="query">
		select 'OFICINA: ' || Oficodigo || '-' || Odescripcion || ' (asignada incorrectamente a ' || cast(cantidad as varchar) || ' grupos de oficinas)' as OFICINA, GOcodigo, GOnombre
		  from rsOficinas
		 where cantidad > 1
		 order by Oficina, GOcodigo
	</cfquery>
	<cf_tabs>
		<cf_tab text="Grupos">
			<div align="center">
				<strong>Grupos de Oficinas asignadas al Tipo</strong>
			</div>
			<br>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsGrupos#"/>
				<cfinvokeargument name="desplegar" value="GOcodigo, GOnombre, oficinasCount"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Grupo de Oficinas, Cantidad Oficinas"/>
				<cfinvokeargument name="formatos" value="V, V, V"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="showemptylistmsg" value="yes"/>
				<cfinvokeargument name="EmptyListMsg" value="No se han asignado Grupos al Tipo de Grupo"/>
				<cfinvokeargument name="showlink" value="no"/>
				<cfinvokeargument name="maxrows" value="0"/>
			</cfinvoke>
		</cf_tab>
		<cfif rsOfiOK.recordCount GT 0>
			<cf_tab text="Correctas">
				<div align="center">
					<strong>Oficinas asignadas correctamente a un Grupo de Oficinas del Tipo</strong>
				</div>
				<br>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsOfiOK#"/>
					<cfinvokeargument name="cortes" value="GRUPO"/>
					<cfinvokeargument name="desplegar" value="Oficodigo, Odescripcion"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Oficina"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="showlink" value="no"/>
					<cfinvokeargument name="maxrows" value="0"/>
				</cfinvoke>
			</cf_tab>
		</cfif>
		<cfif rsOfiNULL.recordCount GT 0>
			<cf_tab text="No Asignadas">
				<div align="center">
					<strong>Oficinas no asignadas a ningún Grupo de Oficinas del Tipo</strong>
				</div>
				<br>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsOfiNULL#"/>
					<cfinvokeargument name="cortes" value="GRUPO"/>
					<cfinvokeargument name="desplegar" value="Oficodigo, Odescripcion"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Oficina"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="showlink" value="no"/>
					<cfinvokeargument name="maxrows" value="0"/>
				</cfinvoke>
			</cf_tab>
		</cfif>
		<cfif rsOfiERR.recordCount GT 0>
			<cf_tab text="Inconsistentes">
				<div align="center">
					<strong>Oficinas asignadas incorrectamente a más de un Grupo de Oficinas del Tipo</strong>
				</div>
				<br>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsOfiERR#"/>
					<cfinvokeargument name="cortes" value="OFICINA"/>
					<cfinvokeargument name="desplegar" value="GOcodigo, GOnombre"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Grupos Oficina"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="showlink" value="no"/>
					<cfinvokeargument name="maxrows" value="0"/>
				</cfinvoke>
			</cf_tab>
		</cfif>
	</cf_tabs>
</cfif>
<cf_web_portlet_end>
<cf_templatefooter>
