<cfset salida = "">
<cfquery name="rsReporteCantReg" datasource="#session.DSN#">
	select count(1) as cantReg
	from ISBmensajesCliente mc
		inner join ISBlogin lo
			on lo.LGnumero=mc.LGnumero
	
		inner join ISBproducto p
			on p.Contratoid=lo.Contratoid
	
		inner join ISBcuenta c
			on c.CTid=p.CTid
	
		inner join ISBpersona per
			on per.Pquien=c.Pquien
	where 1=1
		<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
			and mc.AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
		</cfif>			
		<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
			and upper(lo.LGlogin) like upper('%#url.LGlogin#%')
		</cfif>				
		<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
			and mc.MSfechaCompleto >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
		</cfif>				
		<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
			and mc.MSfechaCompleto <= '#LSDateFormat(url.fechaFin, "yyyymmdd")#'
		</cfif>				
		<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
			and MSoperacion = '#url.MSoperacion#'
		</cfif>	
		<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
			and MSrevAgente = '#url.MSrevAgente#'
		</cfif>	
</cfquery>

<!--- Armado del encabezado --->
<cfset salida = "E^" &
	 LSDateFormat(Now(), "yyyymmdd") & "^" &
	 LSTimeFormat(Now(), 'hh:mm:ss') & "^" & 
	 session.usuario & "^" &
	 rsReporteCantReg.cantReg &
	 chr(13)&chr(10)>
	 
<!--- Armado del detalle --->	
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
			p.CNsuscriptor
			, lo.LGlogin
			, c.CUECUE
			, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2 || ' ' || per.PrazonSocial) as nombreCuenta	
			, mc.MSoperacion
			, mc.MSrevAgente	
			, mc.MSsaldo
			, lo.LGserids
			, p.PQcodigo
			, mot.MBmotivo
			, MSfechaCompleto
					
	from ISBmensajesCliente mc
		inner join ISBlogin lo
			on lo.LGnumero=mc.LGnumero
	
		left join ISBmotivoBloqueo mot
			on mc.MSmotivo = mot.MBmotivo
			
		inner join ISBproducto p
			on p.Contratoid=lo.Contratoid
	
		inner join ISBcuenta c
			on c.CTid=p.CTid
	
		inner join ISBpersona per
			on per.Pquien=c.Pquien
			
		inner join ISBagente ag
			on ag.AGid=mc.AGid
				and ag.Ecodigo=per.Ecodigo
	
		inner join ISBpersona perAG
			on perAG.Pquien=ag.Pquien					
	where 1=1
		<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
			and mc.AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
		</cfif>			
		<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
			and upper(lo.LGlogin) like upper('%#url.LGlogin#%')
		</cfif>				
		<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
			and mc.MSfechaCompleto >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
		</cfif>				
		<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
			and mc.MSfechaCompleto <= '#LSDateFormat(url.fechaFin, "yyyymmdd")#'
		</cfif>				
		<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
			and MSoperacion = '#url.MSoperacion#'
		</cfif>	
		<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
			and MSrevAgente = '#url.MSrevAgente#'
		</cfif>	
	order by LGlogin,CUECUE
</cfquery>			

<cfif isdefined('rsReporte') and rsReporte.recordCount GT 0>
	<cfloop query="rsReporte">
		<cfset salida = salida & "D^">
		<!--- Suscriptor de la cuenta --->
		<cfif rsReporte.CNsuscriptor NEQ ''>
			<cfset salida = salida & rsReporte.CNsuscriptor & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>
		<!--- Login de la cuenta --->		
		<cfif rsReporte.LGlogin NEQ ''>
			<cfset salida = salida & rsReporte.LGlogin & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>		
		<!--- Cuenta siic asignada --->		
		<cfif rsReporte.CUECUE NEQ ''>
			<cfset salida = salida & rsReporte.CUECUE & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>				
		<!--- Nombre de la cuenta --->		
		<cfif rsReporte.nombreCuenta NEQ ''>
			<cfset salida = salida & rsReporte.nombreCuenta & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>			
		<!--- Tipo de tarea --->		
		<cfif rsReporte.MSoperacion NEQ ''>
			<cfset salida = salida & rsReporte.MSoperacion & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>				
		<!--- Fecha-hora de tarea --->		
		<cfset salida = salida & LSDateFormat(rsReporte.MSfechaCompleto, "yyyymmdd") & "^" & LSTimeFormat(rsReporte.MSfechaCompleto, 'hh:mm:ss') & "^">
		<!--- Estado de la tarea --->		
		<cfif rsReporte.MSrevAgente NEQ ''>
			<cfset salida = salida & rsReporte.MSrevAgente & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>				
		<!--- Saldo --->		
		<cfif rsReporte.MSsaldo NEQ ''>
			<cfset salida = salida & rsReporte.MSsaldo & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>
		<!--- Inte --->		
		<cfif rsReporte.LGserids NEQ ''>
			<cfset salida = salida & rsReporte.LGserids & "^">
		<cfelse>
			<cfset salida = salida & "-^">
		</cfif>				
		<!--- Paquete --->		
		<cfif rsReporte.PQcodigo NEQ ''>
			<cfset salida = salida & rsReporte.PQcodigo>
		<cfelse>
			<cfset salida = salida & "-">
		</cfif>					
		<!--- Motivo 		
		<cfif rsReporte.MBmotivo NEQ ''>
			<cfset salida = salida & rsReporte.MBmotivo>
		<cfelse>
			<cfset salida = salida & "-">
		</cfif>		--->				
		<cfset salida = salida & chr(13)&chr(10)>		
	</cfloop>
</cfif>

<!--- ============================================================================================= --->
<!--- Nombre para el archivo .dat  --->
<!--- ============================================================================================= --->		
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '|', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '/', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, ':', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '*', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '?', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '"', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '>', '', 'all') >
<cfset archivo = replace(session.usuario & "_" & session.Usucodigo, '<', '', 'all') >

<!--- ============================================================================================= --->
<!--- Generacion de Archivo DAT --->
<!--- ============================================================================================= --->		
<cfset fullpath = "#expandpath('/saci/consultas/mensajesVende/archExportados')#" >
<cfset datafile = "#expandpath('/saci/consultas/mensajesVende/archExportados/#archivo#.txt')#" >

<cfif Not DirectoryExists(fullpath)>
	<cfdirectory action="create" directory="#fullpath#">
</cfif>

<cffile action="write" nameconflict="overwrite" file="#datafile#" output="#salida#" charset="utf-8">

<cfheader name="Content-Disposition"	value="attachment;filename=#archivo#.txt">
<cfcontent file="#datafile#" type="text/plain" deletefile="yes" >