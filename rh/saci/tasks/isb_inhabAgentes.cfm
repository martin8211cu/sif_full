<cfsetting enablecfoutputonly="no" showdebugoutput="no">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">

<html><head><title>Inhabilitaci&oacute;n de agentes con retrazos en entrega de documentaciones</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfquery name="rsEmpresas" datasource="asp">
	select distinct e.Ecodigo as EcodigoSDC,
					e.Ereferencia as Ecodigo
					, e.CEcodigo
					, c.Ccache as DSN
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  	and c.Cid = e.Cid
	  	and m.SScodigo = 'SACI'
		and e.Ereferencia is not null
		and c.Ccache in ('isb')
</cfquery>

Este proceso se encarga de inhabilitar a los agentes
que se les han acabado los d&iacute;as de plazo establecidos para la entrega
de las documentaciones referentes a las ventas de productos realizadas 
<br /> <br />

<cfoutput query="rsEmpresas">
	Ejecutando @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />
	<cfset Session.Ecodigo = rsEmpresas.Ecodigo>
	<cfset Session.DSN = rsEmpresas.DSN>
	<cfset Session.CEcodigo = rsEmpresas.CEcodigo>
	<cfset Session.ecodigoSDC = rsEmpresas.EcodigoSDC>
	
	<!--- Averiguar el usuario para invocación de Tareas Programadas --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="220" returnvariable="usuario" />
	<!--- Averiguar el plazo maximo de entrega de documentos por parte del agente --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="10" returnvariable="plazoMax" />
	<!--- Averiguar el motivo de bloqueo para Inhabilitación de Agentes --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="228" returnvariable="motivobloqueo"/>
		
	<cfif Len(Trim(usuario))>
		<cfset Session.Usucodigo = usuario>
		<cfset Session.Usuario = usuario>
	<cfelse>
		<cfset Session.Usucodigo = 0>
		<cfset Session.Usuario = 0>
	</cfif>
	
	<!--- Lista de Agentes por empresa con problemas de atrasos en la entrega de documentaciones --->	

	<cfquery name="rsAgentesInhabilitar" datasource="#session.DSN#">
		Select distinct a.AGid
		from ISBproducto p
			inner join ISBvendedor v
				on v.Vid=p.Vid
				and v.Habilitado=1
		
			inner join ISBagente a
				on a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
					and a.AGid=v.AGid
					and a.Habilitado=1
					and a.AAinterno = 0
		
		where p.CTcondicion='0'	
			and p.CNfechaContrato is null
			and datediff(dd,p.CNapertura,getDate()) > (Select coalesce(AAplazoDocumentacion,0)
                                                            From ISBagente x
                                                            Where x.AGid = a.AGid) + <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#" null="#Len(plazoMax) Is 0#">
	</cfquery>	
	
	<cfif isdefined('rsAgentesInhabilitar') and rsAgentesInhabilitar.recordCount GT 0>
		<cfloop query="rsAgentesInhabilitar">			
			<cfinvoke component="saci.comp.ISBagente"
			method="inhabilitarAgente" 
			AGid="#rsAgentesInhabilitar.AGid#"	
			MBmotivo= "#motivobloqueo#"
			BLobs="Inhabilitación Automática de Agente #rsAgentesInhabilitar.AGid#  - #LSDateFormat(now(),'dd/mm/yyyy')#"/>				 	
		</cfloop>
	</cfif>	
			
	<!--- Realizar las notificaciones, cuando vence el periodo de entrega de la documentación--->
	<cfquery name="rsAgentesNotificacion" datasource="#session.DSN#">
		Select distinct a.AGid
		from ISBproducto p
			inner join ISBvendedor v
				on v.Vid=p.Vid
				and v.Habilitado=1
		
			inner join ISBagente a
				on a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
					and a.AGid=v.AGid
					and a.Habilitado=1
					and a.AAinterno = 0
		
		where p.CTcondicion='0'
			and p.CNfechaContrato is null
			and datediff(dd,p.CNapertura,getDate()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#" null="#Len(plazoMax) Is 0#">
	</cfquery>			
	

	<cfif isdefined('rsAgentesNotificacion') and rsAgentesNotificacion.recordCount GT 0>

		<cfloop query="rsAgentesNotificacion">			
				<cfinvoke component="saci.comp.ISBagente"
				method="notificarAgente" 
				AGid="#rsAgentesNotificacion.AGid#"/>				 	
		</cfloop>
	</cfif>		
			
			
 <!--- Si existen Agentes que están deshabilitados automáticamente por incumplimiento del plazo de entrega de documentos,
 	pueden ser habilitados si los contratos fueron aprobados o descartados, osea no existen contratos pendientes 
	posterior el período dado --->

	
	<cfquery name="rsAgentesHabilitar" datasource="#session.DSN#">
	
	Select distinct a.AGid
		from ISBpersona p
			inner join ISBagente a
				on p.Pquien = a.Pquien
				and a.Habilitado=0
				and a.AAinterno = 0
				and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
            inner join ISBvendedor v
                on a.AGid = v.AGid  
                and v.Habilitado = 0  
            inner join ISBcuenta cue
                on a.Pquien = cue.Pquien
            inner join ISBproducto pro
                on cue.CTid = pro.CTid    
            inner join ISBlogin lo
                on pro.Contratoid = lo.Contratoid
                and lo.LGbloqueado = 1
            inner join ISBbloqueoLogin blo   
               on lo.LGnumero = blo.LGnumero
               and MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#motivobloqueo#" null="#Len(motivobloqueo) Is 0#">
               and BLQdesbloquear = 0
    Where  (Select count(*) from ISBproducto x
                        Where x.Vid = v.Vid
                        and x.CTcondicion in ('0')
                        and datediff(dd,x.CNapertura,getDate()) >= (Select coalesce(AAplazoDocumentacion,0) <!--- Contratos que superen el periodo --->
                                                            		From ISBagente x
                                                            		Where x.AGid = a.AGid) +  <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#" null="#Len(plazoMax) Is 0#"> ) = 0
	</cfquery>		
	
	<cfif isdefined('rsAgentesHabilitar') and rsAgentesHabilitar.recordCount GT 0>
		
		<cfloop query="rsAgentesHabilitar">			
			<cfinvoke component="saci.comp.ISBagente"
			method="habilitarAgente" 
			AGid="#rsAgentesHabilitar.AGid#"/>				 	
		</cfloop>
	</cfif>				
			
	Terminado @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />
</cfoutput>

</body>
</html>
