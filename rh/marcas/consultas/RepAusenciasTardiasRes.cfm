<!--- VARIABLES DE TRADUCCION --->
<cfsetting requesttimeout = '8400'>
<cfinvoke key="LB_LlegadaATiempo" default="Llegada a Tiempo" returnvariable="LB_LlegadaATiempo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LlegadaTarde" default="Llegada Tarde" returnvariable="LB_LlegadaTarde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LlegadaTemprano" default="Llegada Temprano" returnvariable="LB_LlegadaTemprano" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LlegadaTardeDiaLibre" default="Llegada Tarde D&iacute;a Libre" returnvariable="LB_LlegadaTardeDiaLibre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LlegadaTempranoDiaLibre" default="Llegada Temprano D&iacute;a libre" returnvariable="LB_LlegadaTempranoDiaLibre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalidaATiempo" default="Salida a Tiempo" returnvariable="LB_SalidaATiempo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalidaTarde" default="Salida Tarde" returnvariable="LB_SalidaTarde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalidaAnticipada" default="Salida Anticipada" returnvariable="LB_SalidaAnticipada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalidaTardeDiaLibre" default="Salida Tarde D&iacute;a Libre" returnvariable="LB_SalidaTardeDiaLibre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SalidaTempranoDiaLibre" default="Salida Temprano D&iacute;a libre" returnvariable="LB_SalidaTempranoDiaLibre" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_Ausencia" default="Ausencia" returnvariable="LB_Ausencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DiaLibre" default="D&iacute;a libre" returnvariable="LB_DiaLibre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>	
<cfinvoke key="LB_FechaDesde" default="Fecha desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaHasta" default="Fecha hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("url.fdesde") and not isdefined('form.fdesde')>
	<cfset form.fdesde= url.fdesde>
</cfif>
<cfif isdefined("url.fhasta") and not isdefined('form.fhasta')>
	<cfset form.fhasta= url.fhasta>
</cfif>
<cfif isdefined("url.CFid") and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>	
<cfif isdefined("url.DEid") and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>	
<cfif isdefined("url.Ingreso") and not isdefined('form.Ingreso')>
	<cfset form.Ingreso = url.Ingreso>
</cfif>	
<cfif isdefined("url.Salida") and not isdefined('form.Salida')>
	<cfset form.Salida = url.Salida>
</cfif>	
<cfif isdefined("url.Orden") and not isdefined('form.Orden')>
	<cfset form.Orden = url.Orden>
</cfif>	

<!--- VARIABLES USO LOCALES --->

<cfset FechaActual = LSDateFormat(Now(),'yyyy/mm/dd')>

<!--- FIN VARIABLES USO LOCALES --->


<style>
	.LetraHora{
		font-size:11px
	}
	.LetraTitulo{
		font-size:14px;
		font-weight:bold;
		padding: 2px;
		background-color:#F0F0F0
	}
	.LetraEmpleado{
		font-size:14px;
		font-weight:bold;
		padding: 2px;
		background-color:#E6E6E6
	}
	.LetraCF{
		font-size:16px;
		font-weight:bold;
		padding: 2px;
		background-color:#DCDCDC
		}
	.LetraN{
		font-size:13px;
		padding: 2px;
		background-color:#DCDCDC
		}
	.LetraP{
		font-size:13px;
		padding: 2px;
		}
</style>
	<!---TABLA DE TRABAJO PARA EL MANEJO DE LOS DATOS---->
	<cf_dbtemp name="ControlAsistencia" returnvariable="ControlAsistencia" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" 	  		  type="numeric"	mandatory="yes"> <!--- Empleado --->
		<cf_dbtempcol name="CFid" 	  		  type="numeric"	mandatory="yes"> <!--- Centro funcional --->
		<cf_dbtempcol name="RHJid" 	  		  type="numeric"	mandatory="yes"> <!--- Jornada --->
		<cf_dbtempcol name="FechaDia" 		  type="datetime"	mandatory="yes"> <!--- Fecha día a Revisar --->
		<cf_dbtempcol name="FechaHoraIngPlan" type="datetime"	mandatory="no">  <!--- Fecha Hora de Ingreso Planificado --->
		<cf_dbtempcol name="FechaHoraSalPlan" type="datetime"	mandatory="no">  <!--- Fecha Hora Salida   Planificado --->
		<cf_dbtempcol name="DiaLibre" 		  type="numeric"	mandatory="no">  <!--- Indica si ese día estaba planeado como Libre o no --->
		<cf_dbtempcol name="Inconsistencia"   type="varchar"	mandatory="no">  <!--- Inconsistencia del día de Marca --->
		<cf_dbtempcol name="CAE" 			  type="numeric"	mandatory="no">  <!--- Antes Entrada --->
		<cf_dbtempcol name="CDE" 			  type="numeric"	mandatory="no">  <!--- Despues Entrada --->
		<cf_dbtempcol name="CAS" 			  type="numeric"	mandatory="no">  <!--- Antes Salida --->
		<cf_dbtempcol name="CDS" 			  type="numeric"	mandatory="no">  <!--- Despues Salida --->
		<cf_dbtempcol name="OcioPlan"		  type="numeric"	mandatory="no">  <!--- Ocio Planificado Jornada --->
	</cf_dbtemp>
	<!--- MARCAS QUE TIENE LOS EMPLEADOS EN RANGO DE FECHAS --->
	<cf_dbtemp name="Marcas" returnvariable="Marcas" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" 	  		  type="numeric"	mandatory="yes"> <!--- Empleado --->
		<cf_dbtempcol name="GrupoMarcas" 	  type="numeric"	mandatory="no"> <!--- Grupo de Marcas --->
		<cf_dbtempcol name="NumLote"   		  type="numeric"	mandatory="no">  <!--- Lote de Marcas Relacionado en el AcumMarcas para determinar el Ocio --->
		<cf_dbtempcol name="FechaGrupo" 	  type="datetime"	mandatory="no">  <!--- Fecha del grupo lote --->
		<cf_dbtempcol name="MinHora" 	  	  type="datetime"	mandatory="no">  <!--- Minima Hora --->
		<cf_dbtempcol name="MaxHora" 	  	  type="datetime"	mandatory="no">  <!--- Maxima Hora --->		
		<cf_dbtempcol name="OcioReal" 	  	  type="numeric"	mandatory="no">  <!--- Ocio Real Segun Marcas --->
	</cf_dbtemp>


	<cfset Lvar_diasig = DateFormat(form.fdesde,'dd/mm/yyyy')>
	<cfloop condition = "Lvar_diasig less than DateFormat(form.fhasta,'dd/mm/yyyy')">
	   	<cfquery name="rsInsertControl" datasource="#session.DSN#">
			insert into  #ControlAsistencia#(DEid,CFid,FechaDia, RHJid, FechaHoraIngPlan, FechaHoraSalPlan,DiaLibre, Inconsistencia,OcioPlan)
			Select DEid, c.CFid,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_diasig#">, 
				b.RHJid, 
				RHJhoraini, 
				RHJhorafin, 
				0, 
				' ', 
				datediff(mi,RHJhorainicom,RHJhorafincom)
			from LineaTiempo a
			inner join RHJornadas b
				on b.RHJid = a.RHJid
			inner join RHPlazas c
				on c.RHPid = a.RHPid
			Where <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_diasig#"> between LTdesde and LThasta
			<cfif isdefined('form.DEid') and form.DEid GT 0 and (not isdefined('form.CFid') or LEN(form.CFid) EQ 0)>
			  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  	</cfif>
			<cfif isdefined('form.CFid') and form.CFid GT 0>
			  and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
	   	</cfquery>
	   	
		<cfset Lvar_diasig = dateadd('d',1,Lvar_diasig)>
	</cfloop>
	<cf_dbfunction name="datediff" args="FechaHoraIngPlan|FechaDia" delimiters="|" returnvariable="Lvar_DifIng" >
	<cf_dbfunction name="datediff" args="FechaHoraSalPlan|FechaDia" returnvariable="Lvar_DifSal" delimiters="|">
	<cf_dbfunction name="dateadd" args="#Lvar_DifIng#|FechaHoraIngPlan" returnvariable="Lvar_AddIng" delimiters="|">
	<cf_dbfunction name="dateadd" args="#Lvar_DifSal#|FechaHoraSalPlan" returnvariable="Lvar_AddSal" delimiters="|">
	<cfquery datasource="#session.DSN#">
		update 	#ControlAsistencia# set
			FechaHoraIngPlan = #Lvar_AddIng#,
			FechaHoraSalPlan = #Lvar_AddSal#
	</cfquery>
	
	<!--- SE BUSCAN LAS MARCAS DE LOS EMPLEADOS --->
	<cfquery name="rsControlMarcas" datasource="#session.DSN#">
		insert into #Marcas# (DEid, GrupoMarcas, FechaGrupo, MinHora, OcioReal, NumLote)
		Select a.DEid, grupomarcas, <cf_dbfunction name="date_format" args="min(fechahoramarca),yyyymmdd">, min(fechahoramarca),0, numlote
		from RHControlMarcas a
			inner join LineaTiempo b
				on b.DEid = a.DEid
			inner join RHPlazas c
				on c.RHPid = b.RHPid
		Where grupomarcas is not null
		  and getdate() between LTdesde and LThasta
		  and <cf_dbfunction name="date_format" args="a.fechahoramarca,yyyymmdd"> 
		  	between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.fdesde),'yyyymmdd')#">
				and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.fhasta),'yyyymmdd')#">
		  and a.DEid in (select  distinct DEid from #ControlAsistencia#)
		Group by a.DEid, grupomarcas, numlote, c.CFid
	</cfquery>
	
	
	<cfquery name="rsUpdateMarcas" datasource="#session.DSN#">
		update #Marcas#
		set MaxHora=(Select Max(fechahoramarca)
					from RHControlMarcas b
					Where #Marcas#.DEid=b.DEid
					and #Marcas#.GrupoMarcas=b.grupomarcas)
		Where exists (Select 1 
					from RHControlMarcas b
					Where #Marcas#.DEid=b.DEid
					and #Marcas#.GrupoMarcas=b.grupomarcas)
	</cfquery>
	
	<!--- SE BUSCAN LAS MARCAS DE LOS EMPLEADOS historicos--->
	
	
	<cfquery name="rsControlMarcas" datasource="#session.DSN#">
		insert into #Marcas# (DEid, GrupoMarcas, FechaGrupo, MinHora, OcioReal, NumLote)
		Select a.DEid, null, <cf_dbfunction name="date_format" args="min(fechahoramarca),yyyymmdd">, min(fechahoramarca),0, numlote
		from RHHControlMarcas a
			inner join LineaTiempo b
				on b.DEid = a.DEid
			inner join RHPlazas c
				on c.RHPid = b.RHPid
		Where numlote is not null
		  and getdate() between LTdesde and LThasta
		  and <cf_dbfunction name="date_format" args="a.fechahoramarca,yyyymmdd"> 
		  	between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.fdesde),'yyyymmdd')#">
				and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.fhasta),'yyyymmdd')#">
		  and a.DEid in (select  distinct DEid from #ControlAsistencia#)
		Group by a.DEid,  numlote, c.CFid
	</cfquery>
	
	
	<cfquery name="rsUpdateMarcas" datasource="#session.DSN#">
		update #Marcas#
		set MaxHora=(Select Max(fechahoramarca)
					from RHHControlMarcas b
					Where #Marcas#.DEid=b.DEid
					and #Marcas#.NumLote=b.numlote)
		Where exists (Select 1 
					from  RHHControlMarcas b
					Where #Marcas#.DEid=b.DEid
					and #Marcas#.NumLote=b.numlote)
	</cfquery>

	<!--- Actualiza la Informacion con los datos del Planificador --->	
	<cfquery name="rsUpdatePlan" datasource="#session.DSN#">
		update #ControlAsistencia#
		set FechaHoraIngPlan = (Select RHPJfinicio 
								 from RHPlanificador b 
								 Where #ControlAsistencia#.DEid=b.DEid
								 and  <cf_dbfunction name="date_format" args="#ControlAsistencia#.FechaDia,yyyymmdd"> = <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd">),
			FechaHoraSalPlan = (Select RHPJffinal 
						     	from RHPlanificador b 
						     	Where #ControlAsistencia#.DEid=b.DEid
						     	and  <cf_dbfunction name="date_format" args="#ControlAsistencia#.FechaDia,yyyymmdd"> = <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd">),
			RHJid		     = (Select RHJid
						     	from RHPlanificador b 
						     	Where #ControlAsistencia#.DEid=b.DEid
						     	and  <cf_dbfunction name="date_format" args="#ControlAsistencia#.FechaDia,yyyymmdd"> = <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd">),
			DiaLibre		 = (Select RHPlibre
						     	from RHPlanificador b 
						     	Where #ControlAsistencia#.DEid=b.DEid
						     	and  <cf_dbfunction name="date_format" args="#ControlAsistencia#.FechaDia,yyyymmdd"> = <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd">)
		Where exists (Select 1
				      from RHPlanificador b
				      Where #ControlAsistencia#.DEid=b.DEid
				        and  <cf_dbfunction name="date_format" args="#ControlAsistencia#.FechaDia,yyyymmdd"> = <cf_dbfunction name="date_format" args="RHPJfinicio,yyyymmdd">)
	</cfquery>
	
	<!--- Actualiza la Informacion del Comportamiento de la Jornada en Base a la Jornada que pagará el Dia --->
	<cfquery name="rsUpdateJornada" datasource="#session.DSN#">
		update #ControlAsistencia#
		set		CAE = (Select coalesce(RHCJperiodot,0)
							from RHComportamientoJornada b 
					   Where #ControlAsistencia#.RHJid=b.RHJid
					   and  RHCJcomportamiento='H'
					   and  RHCJmomento='A'),
				CDE= (Select coalesce(RHCJperiodot,0)
						from RHComportamientoJornada b 
						Where #ControlAsistencia#.RHJid=b.RHJid
						and  RHCJcomportamiento='R'
						and  RHCJmomento='D'),
				CAS	= (Select coalesce(RHCJperiodot,0)
						from RHComportamientoJornada b 
						Where #ControlAsistencia#.RHJid=b.RHJid
						and  RHCJcomportamiento='R'
						and  RHCJmomento='A'),
				CDS	= (Select coalesce(RHCJperiodot,0)
						 from RHComportamientoJornada b 
						Where #ControlAsistencia#.RHJid=b.RHJid
						and  RHCJcomportamiento='H'
						and  RHCJmomento='D'),
				OcioPlan = ( Select <cf_dbfunction name="datediff" args="RHJhorainicom,RHJhorafincom,mi">
							from RHJornadas b 
								Where #ControlAsistencia#.RHJid=b.RHJid)
		Where RHJid is not null
	</cfquery>
	
	<!--- Actualiza la Informacion del Ocio Real con la Informacion del Procesamiento, si este fue generado --->
	<cfquery name="rsUpdateOcioReal" datasource="#session.DSN#">
		update #Marcas#
		set OcioReal = (Select coalesce(CAMociominutos,0)
						from RHCMCalculoAcumMarcas b
						Where #Marcas#.DEid=b.DEid
						and #Marcas#.NumLote=b.CAMid)
		Where exists (Select 1 
						from RHCMCalculoAcumMarcas b
						Where #Marcas#.DEid=b.DEid
						and #Marcas#.NumLote=b.CAMid)
	</cfquery>

	<!--- 
		TIPOS DE MENSAJE PARA LA ENTRADA
		1 LLEGADA TIEMPO
		2 LLEGADA TARDE
		3 LLEGADA TEMPRANO
		4 LLEGADA TARDE EN SU DIA LIBRE
		5 LLEGADA TEMPRANO EN SU DIA LIBRE
		6 DIA LIBRE
		7 AUSENTE
		
		TIPOS DE MENSAJE PARA LA SALIDA
		1 A TIEMPO
		2 SALIDA TARDE
		3 SALIDA ANTICIPADA
		4 SALIDA TARDE EN SU DIA LIBRE
		5 SALIDA ANTICIPADA EN SU DIA LIBRE
		6 DIA LIBRE
		7 AUSENTE
		<cf_dumptable var="#Marcas#">
	 --->
	 
	<cfquery name="rsReporte" datasource="#session.DSN#">
		Select 	a.FechaDia, 
			a.DEid, 
			c.DEidentificacion,
			{fn concat({fn concat({fn concat({fn concat(c.DEapellido1 , ' ' )}, c.DEapellido2 )},  ' ' )}, c.DEnombre)} as Empleado,
			d.CFcodigo,
			d.CFdescripcion,
			DiaLibre,
			a.FechaHoraIngPlan, 
			b.MinHora, 
			case when b.MinHora between <cf_dbfunction name="dateaddx" args="mi,(-1*a.CAE),a.FechaHoraIngPlan">
									and <cf_dbfunction name="dateaddx" args="mi,a.CDE,a.FechaHoraIngPlan"> then 1
				when <cf_dbfunction name="dateaddx" args="mi,a.CDE,a.FechaHoraIngPlan">  < b.MinHora and  DiaLibre= 0 then 2
				when <cf_dbfunction name="dateaddx" args="mi,(-1*a.CAE),a.FechaHoraIngPlan">  > b.MinHora and  DiaLibre= 0 then 3
				when <cf_dbfunction name="dateaddx" args="mi,a.CDE,a.FechaHoraIngPlan"> <  b.MinHora  and  DiaLibre= 1 then 4
				when <cf_dbfunction name="dateaddx" args="mi,(-1*a.CAE),a.FechaHoraIngPlan">  > b.MinHora  and  DiaLibre = 1 then 5
				when b.MinHora is null  and  DiaLibre= 1 then 6
				when b.MinHora is null  and  DiaLibre= 0 then 7
			end  as SituacionIngreso,
			a.FechaHoraSalPlan, 
			b.MaxHora, 
			case when b.MaxHora between 
				<cf_dbfunction name="dateaddx" args="mi,(-1 * a.CAS),a.FechaHoraSalPlan"> and 
				<cf_dbfunction name="dateaddx" args="mi,a.CDS,a.FechaHoraSalPlan">  then 1
				when <cf_dbfunction name="dateaddx" args="mi,(-1 * a.CAS),a.FechaHoraSalPlan"> < b.MaxHora and  DiaLibre= 0 then 2
				when <cf_dbfunction name="dateaddx" args="mi,a.CDS,a.FechaHoraSalPlan"> > b.MaxHora and  DiaLibre= 0 then 3
				when <cf_dbfunction name="dateaddx" args="mi,(-1 * a.CAS),a.FechaHoraSalPlan"> <  b.MaxHora  and  DiaLibre= 1 then 4
				when <cf_dbfunction name="dateaddx" args="mi,a.CDS,a.FechaHoraSalPlan"> > b.MaxHora  and  DiaLibre = 1 then 5
				when b.MinHora is null  and  DiaLibre= 1 then 6
				when b.MinHora is null  and  DiaLibre= 0 then 7
			end  SituacionSalida,
			OcioPlan as OcioPlanMinutos,
			OcioReal as OcioRealMinutos
		from  #ControlAsistencia# a
		left outer join #Marcas# b 
			on b.FechaGrupo = a.FechaDia
			and b.DEid = a.DEid
 		inner join DatosEmpleado c
			on c.DEid = a.DEid
		inner join CFuncional d
			on d.CFid = a.CFid
		order by FechaDia
	</cfquery>
<!---		<cf_dump var="#rsReporte#"> --->

	<cfquery name="rsReporte" dbtype="query">
		select DEid,DEidentificacion,CFcodigo,CFdescripcion,FechaDia,DiaLibre,SituacionIngreso,SituacionSalida,FechaHoraSalPlan,FechaHoraIngPlan,
			   MaxHora,MinHora,OcioPlanMinutos,OcioRealMinutos,Empleado
		from rsReporte
		where 1=1
		<cfif isdefined('form.Ingreso') and form.Ingreso GT -1>
			and SituacionIngreso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ingreso#">
		</cfif>
		<cfif isdefined('form.Salida') and form.Salida GT -1>
			and SituacionSalida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Salida#">
		</cfif>
		<cfif form.Orden eq 1 >
				order by CFcodigo,DEidentificacion
		<cfelseif  form.Orden eq 2 >
				order by CFcodigo,Empleado
		</cfif>
	</cfquery>
	<cfset Lista_InconI = LB_LlegadaATiempo & ','& LB_LlegadaTarde& ','&LB_LlegadaTemprano& ','&LB_LlegadaTardeDiaLibre& ','&LB_LlegadaTempranoDiaLibre& ','&LB_DiaLibre& ','&LB_Ausencia>
	<cfset Lista_InconS = LB_SalidaATiempo& ','&LB_SalidaTarde& ','&LB_SalidaAnticipada& ','&LB_SalidaTardeDiaLibre& ','&LB_SalidaTempranoDiaLibre& ','&LB_DiaLibre& ','&LB_Ausencia>

<!--- 	<cfset Lista_InconS = "Salida a Tiempo,Salida Tarde,Salida Anticipada,Salida Tarde D&iacute;a libre,Salida Temprano D&iacute;a libre,D&iacute;a Libre,Ausente">
	<cfset Lista_InconS = "Salida a Tiempo,Salida Tarde,Salida Anticipada,Salida Tarde D&iacute;a libre,Salida Temprano D&iacute;a libre,D&iacute;a Libre,Ausente">
 --->

	<!--- ENCABEZADO --->
	<table width="100%" cellpadding="3" cellspacing="0" border="0">
		<cfif rsReporte.RecordCount GT 10000>
			<tr><td align="center"><strong><cf_translate key="LB_LaCantidadDeRegistrosSobrepasaElLimite">La cantidad de registros sobrepasa el l&iacute;mite, por favor utilice mas filtros o cambie los seleccionados</cf_translate></strong></td></tr>
		<cfelse>
			<cfoutput>	
			<tr>
				<td colspan="9">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
						<tr>
							<td align="right">
								#LSDateFormat(now(),'dd/mm/yyyy')# - #LSTimeFormat(now(),'HH:mm')#
							</td>
						</tr>	
						<tr > 
							<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
						</tr>
						<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
							<td nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_ReporteDeInconsisitenciasDeMarcas">Reporte de Inconsistencias de Marcas</cf_translate></strong></td>		</strong>
						</tr>
						<tr>
							<td align="center">#LB_FechaDesde#:&nbsp;#LSDateFormat(form.fdesde,'dd/mm/yyyy')#&nbsp;#LB_FechaHasta#:&nbsp;#LSDateFormat(form.fhasta,'dd/mm/yyyy')#</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>
		</cfif>
	</table>
	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
		<cfoutput query="rsReporte" group="CFcodigo">
			<tr  class="LetraCF" ><td colspan="10"><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;#CFcodigo# - #CFdescripcion#</td></tr>
			<cfoutput group="DEid">
				<tr class="LetraEmpleado"><td colspan="10"><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;#DEidentificacion#&nbsp;#Empleado#</td></tr>
				<tr class="LetraTitulo">
					<td><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
					<td><cf_translate key="LB_DiaLibre">D&iacute;a Libre</cf_translate></td>
					<td><cf_translate key="LB_IngresoPlanificado">Ingreso Planificado</cf_translate></td>
					<td><cf_translate key="LB_IngresoRegistrado">Ingreso Registrado</cf_translate></td>
					<td><cf_translate key="LB_Ingreso">Ingreso</cf_translate></td>
					<td><cf_translate key="LB_SalidaPlanificada">Salida Planificada</cf_translate></td>
					<td><cf_translate key="LB_SalidaRegistrada">Salida Registrada</cf_translate></td>
					<td><cf_translate key="LB_Salida">Salida</cf_translate></td>
					<td><cf_translate key="LB_OcioPlanificado">Ocio Planificado</cf_translate></td>
					<td><cf_translate key="LB_OcioRegistrado">Ocio Registrado</cf_translate></td>
				</tr>
				<cfset linea = 0>
				<cfoutput>					
					<tr class="<cfif linea mod 2>LetraN<cfelse>LetraP</cfif> ">
						<td>#LSDateFormat(FechaDia,'dd/mm/yyyy')#</td>
						<td align="center"><cfif DiaLibre EQ 1><cf_translate key="LB_Si">Si</cf_translate><cfelse><cf_translate key="LB_No">No</cf_translate></cfif></td>
						<td>#LSTimeFormat(FechaHoraIngPlan,'HH:MM')#</td>
						<td><cfif LEN(TRIM(MinHora))>#LSTimeFormat(MinHora,'HH:MM')#<cfelse>&nbsp;</cfif></td>
						<td nowrap> 
							<cfif len(trim(SituacionIngreso))>
							#ListGetAt(Lista_InconI,SituacionIngreso)#
							<cfelse>
							-
							</cfif>	
	 					</td>
						<td>#LSTimeFormat(FechaHoraSalPlan,'HH:MM')#</td>
						<td><cfif LEN(TRIM(MaxHora))>#LSTimeFormat(MaxHora,'HH:MM')#<cfelse>&nbsp;</cfif></td>
						<td nowrap>
							<cfif len(trim(SituacionSalida))>
							 #ListGetAt(Lista_InconS,SituacionSalida)#
							<cfelse>
							-
							</cfif>	
							<!---<cfdump var='#rsReporte#'>--->
						</td>
						<td>#OcioPlanMinutos#</td>
						<td>#OcioRealMinutos#</td>
					</tr>
					<cfset linea = linea +1>
				</cfoutput>
				<tr><td>&nbsp;</td></tr>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
		</cfoutput>
	</table>
	


