<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- 
	Se muestran todas las líneas de las solicitudes de compra aplicadas (Estado = 20)
	y que no pertenezcan a ningun proceso de compra en 'procesamiento' (Estado <> 50)
	siempre y cuando sea parte de la especialidad del comprador actual
--->
<cfset LvarEspecializacion = false>
<cfquery name="rsEspecializacionComprador" datasource="#session.dsn#">
	select count(1) as CantidadEspecializacion
	from CMEspecializacionComprador
	where CMCid = #Session.Compras.comprador#
</cfquery>

<cfif rsEspecializacionComprador.CantidadEspecializacion GT 0>
	<cfset LvarEspecializacion = true>
</cfif>

<cfset LvarOrderBy = "a.fechaalta">
<cfif isdefined("form.Colname") and form.Colname neq "">
	<cfset LvarOrderBy = form.Colname>
</cfif>

<!---Determina si la empresa usa Plan de Compras--->
<cfquery name="rsObtenerEstadoPCG" datasource="#Session.DSN#">
	Select 
    	Pvalor
    From 
    	Parametros
    Where 
    	Ecodigo = #Session.Ecodigo# And
        Pcodigo = 2300
</cfquery>

<cf_dbfunction name="to_char" args="e.DSlinea" returnvariable="DSlinea">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/OP/folder-go.gif''>'" returnvariable="DocAD" delimiters="+">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/ftv2folderopen.gif''>'" returnvariable="DocSAD" delimiters="+">

<cfquery name="rsSolicitudesTodo" datasource="#Session.DSN#">
	select 
    	e.DSconsecutivo,
		a.ESestado,
		c.CFcodigo,
		a.ESidsolicitud, 
		b.CMTSdescripcion, 
		a.ESnumero, 
		a.ESobservacion, 
		a.ESfecha, 
        Coalesce(xa.FinishTime , a.ESfechaAplica) as ESfechaAplica,
		c.CFid, 
		c.CFdescripcion, 
		((select min(d.CMSnombre) from CMSolicitantes d where d.CMSid = a.CMSid)) as CMSnombre, 
		e.DSlinea, 
		e.DStotallinest, 
		 '<label style="font-weight:normal" title="'#_Cat# e.DSdescripcion #_Cat#'">' #_Cat# <cf_dbfunction name='sPart' args='e.DSdescripcion|1|50' delimiters='|'> #_Cat# case when <cf_dbfunction name="length" args="e.DSdescripcion"> > 50 then '...' else '' end as DSdescripcion,
		e.DScant, 
		e.DScantsurt, 
		f.Udescripcion, 
		((select min(cfd.CFcodigo)      from CFuncional cfd where cfd.CFid = e.CFid)) as CFcodigoDet, 
		((select min(cfd.CFdescripcion) from CFuncional cfd where cfd.CFid = e.CFid)) as CFdescripcionDet,
		case e.DStipo 
			when 'A' then (select min(Acodigo) from Articulos x where x.Ecodigo = e.Ecodigo and x.Aid = e.Aid) 
		   	when 'S' then (select min(Ccodigo) from Conceptos x where x.Ecodigo = e.Ecodigo and x.Cid = e.Cid) 
		   	else ''
		end as CodigoItem,
        case when (select count(*) from DDocumentosAdjuntos dax where dax.DSlinea= e.DSlinea) > 0
                    then #PreserveSingleQuotes(DocAD)# 
                    else #PreserveSingleQuotes(DocSAD)# 
                    end as Doc, 
        a.CMSid, 
        Coalesce(xa.FinishTime , a.ESfechaAplica) fechaAprobacion
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud b
			<cfif LvarEspecializacion>
				<!--- Chequea cumplimiento de Especialización por Comprador --->
				inner join CMEspecializacionComprador x
				on x.CMCid = #Session.Compras.comprador#
				and x.CMTScodigo = b.CMTScodigo
			</cfif>

		on b.Ecodigo = a.Ecodigo
		and b.CMTScodigo = a.CMTScodigo
        
		LEFT OUTER JOIN WfxActivity xa
        	 on xa.ProcessInstanceId = a.ProcessInstanceid
		inner join CFuncional c
			on c.CFid = a.CFid
		
		inner join DSolicitudCompraCM e
			on  e.ESidsolicitud = a.ESidsolicitud

		left join DOrdenCM DO 
        	on DO.DSlinea = e.DSlinea            
			
		inner join Unidades f
			on f.Ecodigo = e.Ecodigo
			and f.Ucodigo = e.Ucodigo
			
		<cfif isdefined('form.CFid') and Len(Trim(form.CFid))>
			inner join CFuncional g
			on g.CFid = e.CFid
			and g.CFid = #form.CFid#
		</cfif>
		
	where a.CMCid = #Session.Compras.Comprador#
	  and a.ESestado in (20, 40)
	  and a.Ecodigo = #lvarFiltroEcodigo#
      and ((xa.FinishTime        = (select max(sxa.FinishTime) 
            						     from WfxActivity sxa 
                                        where sxa.ProcessInstanceId = xa.ProcessInstanceId))
		  or a.ProcessInstanceid is null)
      <!--- se agrega  validacion para que no permita cancelar OC que se surtieron completamente pero con excesos--->
      and (e.DScant - e.DScantsurt) >=0  

	<cfif isdefined('form.ESnumero_f') and Len(Trim(form.ESnumero_f))>
		and a.ESnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero_f#">
	</cfif>
	<cfif isdefined('form.ESfecha_f') and Len(Trim(form.ESfecha_f))>
		and a.ESfecha = <cfqueryparam value="#LSParseDateTime(form.ESfecha_f)#" cfsqltype="cf_sql_date">
	</cfif>	
	<cfif isdefined('form.ESobservacion_f') and Len(Trim(form.ESobservacion_f))>
		and upper(a.ESobservacion) like '%#UCase(Form.ESobservacion_f)#%'
	</cfif>	 
	<!---Verifica que no exista la linea en seleccion de proveedores y que no haya sido aplicada ahi---->			
			and not exists(select 1
							from DSProvLineasContrato z
							where z.DSlinea = e.DSlinea
								and z.Ecodigo = e.Ecodigo
								and z.Estado = 0
							)	
	<!-----Verificar que la línea no este en una requisición------>
			and not exists (select 1 
							from DRequisicion p
							where p.DSlinea = e.DSlinea
							)											
	<!--- Chequea que sean líneas que no pertenezcan a otro Proceso de Compra, con excepción de los Procesos Cerrados --->
			and not exists (
				select 1
				from CMLineasProceso x
					inner join CMProcesoCompra y
					on y.CMPid = x.CMPid
					and y.CMPestado <> 50 and y.CMPestado <> 85
				where x.DSlinea = e.DSlinea
			<cfif modo EQ "CAMBIO">
				and x.CMPid <> #Session.Compras.ProcesoCompra.CMPid#
			</cfif>
			)					
	<!--- Chequea que sean líneas que no pertenezcan a ninguna Orden de Compra y que no este cancelada, para evitar mostrar las líneas que hayan sido generadas por Contrato --->
			and not exists (
				select 1
				from DOrdenCM x
					inner join EOrdenCM y
					on y.EOidorden = x.EOidorden
					and y.EOestado <> 60 <!---Cancelada --->
					and y.EOestado <> 55 <!---Cancelada Parcialmente Surtida --->
					and y.EOestado <> 10 <!---Aplicada---> 
					and y.EOestado <> 70 <!---Anulada--->	
				where x.DSlinea = e.DSlinea
			)            
			<cfif ProcesoPublicado>
	<!--- Muestra solo las líneas para el Proceso de Compra cuando éste ya ha sido publicado --->
				and exists (
					select 1
					from CMLineasProceso x
					where x.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					and x.DSlinea = e.DSlinea
				)
			</cfif>
			
		   <!---
		   and (e.DScant - e.DScantsurt != 0)            
		<cfif #rsObtenerEstadoPCG.Pvalor# EQ '1'>
            and e.DScant > Coalesce(DO.DOcantidad, 0)
        </cfif>--->       
		
		<cfif #rsObtenerEstadoPCG.Pvalor# EQ '1'>
            <!--- Se verifica si la resta de la cantidad de la solicitud, menos la cantidad surtida es mayor a cero--->
            <!--- Si DScontrolCantidad es 0, entonces se verifica si ya una OC puso la surtida en uno, si es asi no se muestra esta linea --->
            <!--- DScontrolCantidad se utiliza en el plan de compras para indicar si el objeto que se esta surtiendo hay que llevar el control de --->
            <!--- la cantidad que se va surtiendo, por el contrario si no se controla la cantidad entonces este solo se puede surtir a partir de una orden de compra. --->
            <!--- por esta razón es que se coloca un 1 en la cantidad surtida, ya que es no importa la cantidad que se surta a la OC --->        
             And (e.DScant - (
                    Select Case x1.DScontrolCantidad 
                            When 0 Then 
                                Case x1.DScantsurt
                                    When 1 Then
                                        x1.DScant
                                    Else 0
                                End
                            Else x1.DScantsurt
                        End	
                    From DSolicitudCompraCM x1 Where x1.DSlinea = e.DSlinea) > 0)
            <cfelse>
                And (e.DScant - e.DScantSurt) > 0
            </cfif>
            And (e.DScant -
                   Coalesce((Select Sum(x2.DOcantidad-coalesce(x2.DOcantCancel,0))
										From DOrdenCM x2 Inner Join EOrdenCM x3 On x3.EOidorden = x2.EOidorden
										Where x2.DSlinea = e.DSlinea And (x3.EOestado = 5 Or x3.EOestado = 10)), 0)) > 0

            And e.DScant >= 0 
			And e.DScantSurt >= 0      
         order by Coalesce(xa.FinishTime , a.ESfechaAplica)
</cfquery>


<cfquery name="rsSolicitudesList" datasource="#Session.DSN#">
select DPCecodigo as Ecodigo, Edescripcion,(
	select DISTINCT
    	count(1)
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud b
			<cfif LvarEspecializacion>
				<!--- Chequea cumplimiento de Especialización por Comprador --->
				inner join CMEspecializacionComprador x
				on x.CMCid = #Session.Compras.comprador#
				and x.CMTScodigo = b.CMTScodigo
			</cfif>

		on b.Ecodigo = a.Ecodigo
		and b.CMTScodigo = a.CMTScodigo
        
		LEFT OUTER JOIN WfxActivity xa
        	 on xa.ProcessInstanceId = a.ProcessInstanceid
           
            
		inner join CFuncional c
			on c.CFid = a.CFid
		
		inner join DSolicitudCompraCM e
			on  e.ESidsolicitud = a.ESidsolicitud

		left join DOrdenCM DO 
        	on DO.DSlinea = e.DSlinea            
			
		inner join Unidades f
			on f.Ecodigo = e.Ecodigo
			and f.Ucodigo = e.Ucodigo
			
		<cfif isdefined('form.CFid') and Len(Trim(form.CFid))>
			inner join CFuncional g
			on g.CFid = e.CFid
			and g.CFid = #form.CFid#
		</cfif>
		
	where a.CMCid = #Session.Compras.Comprador#
	  and a.ESestado in (20, 40)
	  and a.Ecodigo = dpc.DPCecodigo
	   and ((xa.FinishTime        = (select max(sxa.FinishTime) 
            						     from WfxActivity sxa 
                                        where sxa.ProcessInstanceId = xa.ProcessInstanceId))
			or  a.ProcessInstanceid is null)
      <!--- se agrega  validacion para que no permita cancelar OC que se surtieron completamente pero con excesos--->
      and (e.DScant - e.DScantsurt) >=0  

	
	<!---Verifica que no exista la linea en seleccion de proveedores y que no haya sido aplicada ahi---->			
			and not exists(select 1
							from DSProvLineasContrato z
							where z.DSlinea = e.DSlinea
								and z.Ecodigo = e.Ecodigo
								and z.Estado = 0
							)	
	<!-----Verificar que la línea no este en una requisición------>
			and not exists (select 1 
							from DRequisicion p
							where p.DSlinea = e.DSlinea
							)											
	<!--- Chequea que sean líneas que no pertenezcan a otro Proceso de Compra, con excepción de los Procesos Cerrados --->
			and not exists (
				select 1
				from CMLineasProceso x
					inner join CMProcesoCompra y
					on y.CMPid = x.CMPid
					and y.CMPestado <> 50 and y.CMPestado <> 85
				where x.DSlinea = e.DSlinea
			<cfif modo EQ "CAMBIO">
				and x.CMPid <> #Session.Compras.ProcesoCompra.CMPid#
			</cfif>
			)					
	<!--- Chequea que sean líneas que no pertenezcan a ninguna Orden de Compra y que no este cancelada, para evitar mostrar las líneas que hayan sido generadas por Contrato --->
			and not exists (
				select 1
				from DOrdenCM x
					inner join EOrdenCM y
					on y.EOidorden = x.EOidorden
					and y.EOestado <> 60 <!---Cancelada --->
					and y.EOestado <> 55 <!---Cancelada Parcialmente Surtida --->
					and y.EOestado <> 10 <!---Aplicada---> 
					and y.EOestado <> 70 <!---Anulada--->	
				where x.DSlinea = e.DSlinea
			)            
			<cfif ProcesoPublicado>
	<!--- Muestra solo las líneas para el Proceso de Compra cuando éste ya ha sido publicado --->
				and exists (
					select 1
					from CMLineasProceso x
					where x.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					and x.DSlinea = e.DSlinea
				)
			</cfif>
		and (e.DScant - e.DScantsurt != 0)            
		<cfif #rsObtenerEstadoPCG.Pvalor# EQ '1'>
            and e.DScant > Coalesce(DO.DOcantidad, 0)
        </cfif>   
		) as numSol 
	from DProveduriaCorporativa dpc
		inner join Empresas e
		on e.Ecodigo = dpc.DPCecodigo
		where dpc.Ecodigo = #session.Ecodigo# or dpc.DPCecodigo=#session.Ecodigo#
		<cfif isdefined("rsEProvCorp")>
			and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
		</cfif>
	union
	
		select e.Ecodigo, e.Edescripcion, 
		(select DISTINCT
    	count(1)
	from ESolicitudCompraCM a
		inner join CMTiposSolicitud b
			<cfif LvarEspecializacion>
				<!--- Chequea cumplimiento de Especialización por Comprador --->
				inner join CMEspecializacionComprador x
				on x.CMCid = #Session.Compras.comprador#
				and x.CMTScodigo = b.CMTScodigo
			</cfif>

		on b.Ecodigo = a.Ecodigo
		and b.CMTScodigo = a.CMTScodigo
        
		LEFT OUTER JOIN WfxActivity xa
        	 on xa.ProcessInstanceId = a.ProcessInstanceid
            
		inner join CFuncional c
			on c.CFid = a.CFid
		
		inner join DSolicitudCompraCM e
			on  e.ESidsolicitud = a.ESidsolicitud

		left join DOrdenCM DO 
        	on DO.DSlinea = e.DSlinea            
			
		inner join Unidades f
			on f.Ecodigo = e.Ecodigo
			and f.Ucodigo = e.Ucodigo
			
		<cfif isdefined('form.CFid') and Len(Trim(form.CFid))>
			inner join CFuncional g
			on g.CFid = e.CFid
			and g.CFid = #form.CFid#
		</cfif>
		
	where a.CMCid = #Session.Compras.Comprador#
	  and a.ESestado in (20, 40)
	  and a.Ecodigo = e.Ecodigo
	  
	  and ((xa.FinishTime        = (select max(sxa.FinishTime) 
            						     from WfxActivity sxa 
                                        where sxa.ProcessInstanceId = xa.ProcessInstanceId) )
		 or a.ProcessInstanceid is null)
      <!--- se agrega  validacion para que no permita cancelar OC que se surtieron completamente pero con excesos--->
      and (e.DScant - e.DScantsurt) >=0  

	
	<!---Verifica que no exista la linea en seleccion de proveedores y que no haya sido aplicada ahi---->			
			and not exists(select 1
							from DSProvLineasContrato z
							where z.DSlinea = e.DSlinea
								and z.Ecodigo = e.Ecodigo
								and z.Estado = 0
							)	
	<!-----Verificar que la línea no este en una requisición------>
			and not exists (select 1 
							from DRequisicion p
							where p.DSlinea = e.DSlinea
							)											
	<!--- Chequea que sean líneas que no pertenezcan a otro Proceso de Compra, con excepción de los Procesos Cerrados --->
			and not exists (
				select 1
				from CMLineasProceso x
					inner join CMProcesoCompra y
					on y.CMPid = x.CMPid
					and y.CMPestado <> 50 and y.CMPestado <> 85
				where x.DSlinea = e.DSlinea
			<cfif modo EQ "CAMBIO">
				and x.CMPid <> #Session.Compras.ProcesoCompra.CMPid#
			</cfif>
			)					
	<!--- Chequea que sean líneas que no pertenezcan a ninguna Orden de Compra y que no este cancelada, para evitar mostrar las líneas que hayan sido generadas por Contrato --->
			and not exists (
				select 1
				from DOrdenCM x
					inner join EOrdenCM y
					on y.EOidorden = x.EOidorden
					and y.EOestado <> 60 <!---Cancelada --->
					and y.EOestado <> 55 <!---Cancelada Parcialmente Surtida --->
					and y.EOestado <> 10 <!---Aplicada---> 
					and y.EOestado <> 70 <!---Anulada--->	
				where x.DSlinea = e.DSlinea
			)            
			<cfif ProcesoPublicado>
	<!--- Muestra solo las líneas para el Proceso de Compra cuando éste ya ha sido publicado --->
				and exists (
					select 1
					from CMLineasProceso x
					where x.CMPid = #Session.Compras.ProcesoCompra.CMPid#
					and x.DSlinea = e.DSlinea
				)
			</cfif>
		and (e.DScant - e.DScantsurt != 0)            
		<cfif #rsObtenerEstadoPCG.Pvalor# EQ '1'>
            and e.DScant > Coalesce(DO.DOcantidad, 0)
        </cfif> ) as numSol
		from Empresas e
			where e.Ecodigo = #session.Ecodigo#
		order by 2
</cfquery>

<cfset lvarESidsolicituds = ValueList(rsSolicitudesTodo.ESidsolicitud)>
<cfif rsSolicitudesTodo.recordCount EQ 0>
	<cfif isdefined('Session.Compras.ProcesoCompra.PrimeraVez') and Session.Compras.ProcesoCompra.PrimeraVez>
		<cfset Session.Compras.ProcesoCompra.Pantalla = "0">
		<cfset Session.Compras.ProcesoCompra.PrimeraVez = false>
		<cflocation url="#GetFileFromPath(GetTemplatePath())#">
	</cfif>
    <cfset lvarESidsolicituds = -1>
</cfif>

<cfquery name="rsSolicitudes" dbtype="query">
	select distinct ESidsolicitud, ESfechaAplica, CMTSdescripcion, ESnumero, ESobservacion, ESfecha, CFcodigo, CFdescripcion, CMSnombre
	from rsSolicitudesTodo
	order by ESfechaAplica
</cfquery>
<cfquery name="rsAprobadores" datasource="#session.DSN#">
	select coalesce(xap.Usucodigo,sc.Usucodigo) as Aprobador, DSlinea, CMTSaprobarsolicitante
    from ESolicitudCompraCM sc
    	inner join DSolicitudCompraCM  ds
			on  ds.ESidsolicitud = sc.ESidsolicitud			
			and (ds.DScant - ds.DScantsurt != 0)
       	inner join CMTiposSolicitud ts
        	on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo
        left outer join WfxActivity xa
            inner join WfxActivityParticipant xap
                inner join UsuarioReferencia ur
                    on ur.Usucodigo  = xap.Usucodigo
                        and ur.Ecodigo = #session.EcodigoSDC#
                        and ur.STabla = 'DatosEmpleado'
                on xap.ActivityInstanceId = xa.ActivityInstanceId and xap.HasTransition = 1
            on xa.ProcessInstanceId = sc.ProcessInstanceid 
    where sc.Ecodigo = #lvarFiltroEcodigo#
    and sc.ESestado in (20, 40)
	and ((xa.FinishTime = (select max(sxa.FinishTime)
                                    from WfxActivity sxa
                                        inner join WfxActivityParticipant sxap
                                            on sxap.ActivityInstanceId = sxa.ActivityInstanceId
                                    where sxa.ProcessInstanceId = sc.ProcessInstanceid))
		 or sc.ProcessInstanceid is null)
    and sc.ESidsolicitud in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarESidsolicituds#" list="yes">)
</cfquery>
<cfset iCount = 1>
<cfoutput>
	<script type="text/javascript" language="javascript" src="/cfmx/CFIDE/scripts/wddx.js"></script>
	<script type="text/javascript" language="JavaScript">
		function funcChkAll(c) {
			if (document.form1.ESidsolicitud) {
				if (document.form1.ESidsolicitud.value) {
					if (!document.form1.ESidsolicitud.disabled) { 
						document.form1.ESidsolicitud.checked = c.checked;
						funcChkSolicitud(document.form1.ESidsolicitud);
					}
				} else {
					for (var counter = 0; counter < document.form1.ESidsolicitud.length; counter++) {
						if (!document.form1.ESidsolicitud[counter].disabled) {
							document.form1.ESidsolicitud[counter].checked = c.checked;
							funcChkSolicitud(document.form1.ESidsolicitud[counter]);
						}
					}
				}
			}
		}

		function UpdChkAll(c) {
			var allChecked = true;
			if (!c.checked) {
				allChecked = false;
			} else {
				if (document.form1.ESidsolicitud.value) {
					if (!document.form1.ESidsolicitud.disabled) allChecked = true;
				} else {
					for (var counter = 0; counter < document.form1.ESidsolicitud.length; counter++) {
						if (!document.form1.ESidsolicitud[counter].disabled && !document.form1.ESidsolicitud[counter].checked) {allChecked=false; break;}
					}
				}
			}
			document.form1.chkAllItems.checked = allChecked;
		}
		
		function funcChkSolicitud(c) {
			if (document.form1['DSlinea_'+c.value]) {
				if (document.form1['DSlinea_'+c.value].value) {
					if (!document.form1['DSlinea_'+c.value].disabled) document.form1['DSlinea_'+c.value].checked = c.checked;
				} else {
					for (var counter = 0; counter < document.form1['DSlinea_'+c.value].length; counter++) {
						if (!document.form1['DSlinea_'+c.value][counter].disabled) document.form1['DSlinea_'+c.value][counter].checked = c.checked;
					}
				}
			}
		}

		function UpdChkSolicitud(c) {
			var idSolic = "" + c.name.split('_')[1];
			
			var allChecked = true;

			if (!c.checked) {
				allChecked = false;
			} else {
				if (document.form1['DSlinea_'+idSolic].value) {
					if (!document.form1['DSlinea_'+idSolic].disabled) allChecked = true;
				} else {
					for (var counter = 0; counter < document.form1['DSlinea_'+idSolic].length; counter++) {
						if (!document.form1['DSlinea_'+idSolic][counter].disabled && !document.form1['DSlinea_'+idSolic][counter].checked) {
							allChecked=false; break;
						}
					}
				}
			}

			if (document.form1.ESidsolicitud.value) {
				document.form1.ESidsolicitud.checked = allChecked;
				UpdChkAll(document.form1.ESidsolicitud);
			} else {
				for (var counter = 0; counter < document.form1.ESidsolicitud.length; counter++) {
					if (!document.form1.ESidsolicitud[counter].disabled && document.form1.ESidsolicitud[counter].value == idSolic) {
						document.form1.ESidsolicitud[counter].checked = allChecked; 
						UpdChkAll(document.form1.ESidsolicitud[counter]);
						break;
					}
				}
			}
		}
		
		function checkContinuar() {
			var continuar = false;
			DSlineas = "";
			if (document.form1.ESidsolicitud) {
				if (document.form1.ESidsolicitud.value) {
					if (document.form1['DSlinea_'+document.form1.ESidsolicitud.value].value) {
						if (!document.form1['DSlinea_'+document.form1.ESidsolicitud.value].disabled){
							continuar = document.form1['DSlinea_'+document.form1.ESidsolicitud.value].checked;
							DSlineas = document.form1['DSlinea_'+document.form1.ESidsolicitud.value].value; 
						}
					} else {
						for (var counter = 0; counter < document.form1['DSlinea_'+document.form1.ESidsolicitud.value].length; counter++) {
							if (!document.form1['DSlinea_'+document.form1.ESidsolicitud.value][counter].disabled && document.form1['DSlinea_'+document.form1.ESidsolicitud.value][counter].checked) {
								continuar = true;
								DSlineas = DSlineas + document.form1['DSlinea_'+document.form1.ESidsolicitud.value][counter].value + ","; 
							}
						}
					}
				} else {
					for (var k = 0; k < document.form1.ESidsolicitud.length; k++) {
						if (document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value].value) {
							if (!document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value].disabled && document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value].checked){
								continuar = true;
								DSlineas = DSlineas + document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value].value + ","; 
							}
						} else {
							for (var counter = 0; counter < document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value].length; counter++) {
								if (!document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value][counter].disabled && document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value][counter].checked) {
									continuar = true;
									DSlineas = DSlineas + document.form1['DSlinea_'+document.form1.ESidsolicitud[k].value][counter].value + ","; 
								}
							}
						}
					}
				}
				if (!continuar) alert('Debe seleccionar al menos un item de compra');
				if(fnPermiteAgrupacion(DSlineas)){
					continuar = false;
					alert('Existe una solicitud con el tipo de solicituda marcada como "Cotizaciones Aprobadas por Solicitante", solo se permite solcitudes del mismo tipo cuando esta activado, además el aprobador del tramite debe de ser el mismo para todas.');
				}
			} else {
				alert('No existen itemes de compra para iniciar un nuevo proceso de compra')
			}
			return continuar;
		}
		function fnPermiteAgrupacion(DSlineas){
			DSlinea = DSlineas.split(',');
			<cfwddx action="cfml2js" input="#rsAprobadores#" topLevelVariable="rsAprobadores"> 
			var nRows = rsAprobadores.getRowCount();
			validaAprobador = false;
			validaSolicitante = false;
			aprobadorValue = 0;
			if(nRows > 0){
				for(i = 0; i < DSlinea.length; ++i){
					if(DSlinea[i] == '')
						break;
					for(row = 0; row < nRows; ++row){
						if(rsAprobadores.getField(row, "DSlinea") == DSlinea[i]){
							if(aprobadorValue == 0)
								aprobadorValue = rsAprobadores.getField(row, "Aprobador");
							validaSolicitante = validaSolicitante || (rsAprobadores.getField(row, "CMTSaprobarsolicitante") == 1 ? true : false );
							validaAprobador = validaAprobador || (rsAprobadores.getField(row, "Aprobador") != aprobadorValue ? true : false );
						}
					}
				}
			}
			return validaSolicitante && validaAprobador;
		}
		function AlmacenarObjetos(valor){
			if (valor != ""){			
				var PARAM  = "ObjetosSolicitudes.cfm?Modulo=SC&DSlinea1="+valor;
				open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');	
			}
			return false;
		}
		function fnImprimir(ESidsolicitud,ESnumero,CMSid){
			if (ESidsolicitud != ""){			
				var PARAM  = "solicitudesReimprimir-sql.cfm?PC=true&ESidsolicitud="+ESidsolicitud+"&ESnumero="+ESnumero+"&CMSid="+CMSid;
				open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');	
			}
			return false;
		}
	</script>
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
	<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
		<input type="hidden" name="opt" value="">
		<cfif isdefined('form.CMPid') and form.CMPid NEQ ''>
			<input type="hidden" name="CMPid" value="#form.CMPid#">
		</cfif>
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		 
		  <tr>
			<td>
			<table width="100%"  border="0" class="areaFiltro">
                <tr>
                  <td width="15%" align="right"><strong>Solicitud:</strong></td>
                  <td width="19%">
					<input type="text" name="ESnumero_f" id="ESnumero_f" style="text-align:right"size="15" maxlength="10" 
					onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
					onFocus="javascript:this.select();" 
					onChange="javascript: fm(this,-1);"
					value="<cfif isdefined('form.ESnumero_f') and form.ESnumero_f NEQ ''><cfoutput>#form.ESnumero_f#</cfoutput></cfif>">				  </td>
                  <td width="9%" align="right"><strong>Fecha:</strong></td>
                  <td width="16%">
				    <cfset fechadoc = ''>
					<cfif isdefined('form.ESfecha_f') and form.ESfecha_f NEQ ''>
						<cfset fechadoc = form.ESfecha_f>
					</cfif>
					
					<cf_sifcalendario value="#fechadoc#" name="ESfecha_f">				  </td>
                  <td width="21%" nowrap align="right"><strong>Centro Funcional: </strong></td>
                  <td width="20%">
					<cfif isdefined('form.CFcodigo_f') and form.CFcodigo_f NEQ ''>
						<cfquery name="rsCFuncional" datasource="#session.DSN#">
							Select CFid,CFcodigo as CFcodigo_f,CFdescripcion
							from CFuncional
							where Ecodigo= #lvarFiltroEcodigo#
								and CFcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFcodigo_f#">
						</cfquery>					
						<cfif isdefined('rsCFuncional') and rsCFuncional.recordCount GT 0>
							<cf_rhcfuncional name="CFcodigo_f" query="#rsCFuncional#" Ecodigo="#lvarFiltroEcodigo#">
						<cfelse>
							<cf_rhcfuncional name="CFcodigo_f" Ecodigo="#lvarFiltroEcodigo#">
						</cfif>
					<cfelse>
						<cf_rhcfuncional name="CFcodigo_f" Ecodigo="#lvarFiltroEcodigo#">
					</cfif>				  </td>
                </tr>
                <tr>
                  <td align="right"><strong>Descripcion:</strong></td>
                  <td <cfif not lvarProvCorp>colspan="3"</cfif>><input name="ESobservacion_f" value="<cfif isdefined('form.ESobservacion_f') and form.ESobservacion_f NEQ ''><cfoutput>#form.ESobservacion_f#</cfoutput></cfif>" type="text" id="ESobservacion_f" size="<cfif lvarProvCorp>30<cfelse>60</cfif>" maxlength="255"></td>
                  <cfif lvarProvCorp>
                    <td align="right" nowrap><strong>Empresa: </strong></td>
                    <td>
                        <select name="Ecodigo_f" <cfif ProcesoPublicado>disabled</cfif>>
                            <cfloop query="rsDProvCorp">
                                <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Compras.ProcesoCompra.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                            </cfloop>	
                        </select></td>
                  </cfif>
                  <td colspan="2" align="center"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" /></td>
                </tr>
              </table>		
			</td>		
		  </tr>
		<!--- Lista de solicitudes de todas las empresas--->
		<cfquery name="rsnsolicitudes" dbtype="query">
			select distinct * from rsSolicitudesList
			where Ecodigo <> #lvarFiltroEcodigo#
			and numSol > 0
		</cfquery>
		<cfif rsnsolicitudes.recordcount GT 0>
		  <tr>
			<td>
				<table align="left" cellspacing="0" cellpadding="0" border="0">
					<tr bgcolor="##D7DCE0" >
						<td colspan="2" align="center">&nbsp;<b>Lista de Empresas Con Solicides</b>&nbsp;</td>
					</tr>
					<tr bgcolor="##D7DCE0" >
						<td>&nbsp;<b>Empresa</b>&nbsp;</td><td>&nbsp;<b>No Registros</b>&nbsp;</td>
					</tr>
		<cfset tmpnon=0>
		<cfloop query="rsnsolicitudes">
			
					<tr bgcolor="<cfif tmpnon EQ 0><cfset tmpnon=1>##fafafa<cfelse><cfset tmpnon=0>##f2f2f2</cfif>" >
						<td colspan="1">&nbsp;#rsnsolicitudes.Edescripcion#&nbsp;</td>
						<td colspan="1" align="center">&nbsp;#rsnsolicitudes.numSol#&nbsp;</td>
					</tr>
			
		</cfloop>
				</table>
			</td>
		</tr>
		</cfif>
		  <tr>
			<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
			  	<tr align="center">
					<td colspan="6">
						<cfif ProcesoPublicado>
						  <input type="submit"  name="btnContinuar2" class="btnNormal" value="Continuar >>" onclick="javascript: funcSiguiente();" />
						<cfelse>
							<input type="submit"  name="btnGuardar" class="btnGuardar"  value="Guardar y Continuar >>" onClick="javascript: funcSiguiente();  return checkContinuar();">
						</cfif>					</td>
			  	</tr>
				  <tr>
					<td colspan="6">&nbsp;</td>
				  </tr>
				  <tr>
					<td nowrap class="tituloListas"><input type="checkbox" name="chkAllItems" value="1" onClick="javascript: funcChkAll(this);" style="border:none;" <cfif ProcesoPublicado>disabled</cfif>></td>
					<td nowrap class="tituloListas" style="padding-right: 5px;" >Tipo de Solicitud</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;" align="right" >No. Solicitud</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;" align="center" >Fecha<br />Solicitud</td>
                    <td nowrap class="tituloListas" style="padding-right: 5px;" align="center" >Fecha <br />(Aplic/Aprob)</td>
					<td nowrap class="tituloListas" style="padding-right: 5px;">Centro Funcional</td>
					<td nowrap class="tituloListas">Solicitante</td>
				  </tr>
				  <cfflush interval="64">
				  <cfif rsSolicitudes.recordCount GT 0>
				  	  
					  <cfloop query="rsSolicitudes">
						  <cfset solicitud = rsSolicitudes.ESidsolicitud>
						  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
							<td width="1%" nowrap><input type="checkbox" name="ESidsolicitud" value="#rsSolicitudes.ESidsolicitud#" onClick="javascript: funcChkSolicitud(this); UpdChkAll(this);" style="border:none;" <cfif ProcesoPublicado>disabled</cfif>></td>
							<td style="padding-right: 5px;" nowrap><strong>#rsSolicitudes.CMTSdescripcion#</strong></td>
							<td align="center"  style="padding-right: 5px;"nowrap><strong>#rsSolicitudes.ESnumero#</strong></td>
							<td style="padding-right: 5px;" align="center" nowrap><strong>#LSDateFormat(rsSolicitudes.ESfecha, 'dd/mm/yyyy')#</strong></td>
							<td style="padding-right: 5px;" align="center" nowrap><strong>#LSDateFormat(rsSolicitudes.ESfechaAplica, 'dd/mm/yyyy')#</strong></td>
                            <td style="padding-right: 5px;" nowrap><strong>#rsSolicitudes.CFcodigo# - #rsSolicitudes.CFdescripcion#</strong></td>
							<td><strong>#rsSolicitudes.CMSnombre#</strong></td>
						  </tr>
						  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
							<td>&nbsp;</td>
							<td colspan="5" align="">
								<strong>#rsSolicitudes.ESobservacion#</strong>							</td>
						  </tr>
						  <cfset iCount = iCount + 1>
						  <cfquery name="rsSolicitudesDetalle" dbtype="query">
							select distinct DSlinea, CodigoItem, Doc,
							DSdescripcion,DSconsecutivo,
						    DScant, DScantsurt, Udescripcion, ESidsolicitud, CFcodigoDet, CFdescripcionDet, DStotallinest, ESnumero, CMSid
							from rsSolicitudesTodo
							where ESidsolicitud = #rsSolicitudes.ESidsolicitud#
							order by DSconsecutivo
						  </cfquery>
						  <tr>
							<td nowrap>&nbsp;</td>
							<td colspan="6" nowrap>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td style="padding-right: 5px;" class="tituloListas" width="2%" nowrap align="center">&nbsp;</td>
                                    <td style="padding-right: 5px;" class="tituloListas" width="5%" nowrap align="center">Línea</td>
									<td style="padding-right: 5px;" class="tituloListas" width="20%" nowrap align="center">Item</td>
									<td style="padding-right: 5px;" width="9%" align="center" nowrap class="tituloListas">Cantidad</td>
									<td class="tituloListas" width="15%" nowrap align="center">Unidad</td>
									<td class="tituloListas" width="15%" nowrap align="center">Monto</td>
									<td class="tituloListas" width="42%" nowrap align="center">Ctro. Funcional</td>
                                    <td class="tituloListas" width="42%" nowrap>&nbsp;</td>
								  </tr>
								<cfloop query="rsSolicitudesDetalle">
								  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
									<td style="padding-right: 5px;" nowrap align="center">
										<!--- Cuando ya habia items seleccionados anteriormente y cargados en session --->
										<cfif isdefined("Session.Compras.ProcesoCompra.DSlinea") and LEN(TRIM(Session.Compras.ProcesoCompra.DSlinea))>
											<input type="checkbox" name="DSlinea_#solicitud#" value="#rsSolicitudesDetalle.DSlinea#" onClick="javascript: UpdChkSolicitud(this);" <cfif FindNoCase(","&rsSolicitudesDetalle.DSlinea&",", ","&Session.Compras.ProcesoCompra.DSlinea&",") NEQ 0> checked</cfif> style="border:none;" <cfif ProcesoPublicado>disabled</cfif>>
										<cfelse>
											<input type="checkbox" name="DSlinea_#solicitud#" value="#rsSolicitudesDetalle.DSlinea#" onClick="javascript: UpdChkSolicitud(this);" style="border:none;" <cfif ProcesoPublicado>disabled</cfif>>
										</cfif>									</td>
									<td style="padding-right: 5px;" nowrap align="center">#rsSolicitudesDetalle.DSconsecutivo#</td>
                                    <td style="padding-right: 5px;" nowrap align="center">#rsSolicitudesDetalle.CodigoItem# - #rsSolicitudesDetalle.DSdescripcion#</td>
									<td style="padding-right: 5px;" align="center" nowrap >#rsSolicitudesDetalle.DScant - rsSolicitudesDetalle.DScantsurt#</td>
									<td nowrap align="center">#rsSolicitudesDetalle.Udescripcion#</td>
									<td nowrap align="center">#NumberFormat(rsSolicitudesDetalle.DStotallinest,'9,9.99')#</td>
									<td nowrap align="center">
										<cfif Len(Trim(rsSolicitudesDetalle.CFcodigoDet))>
											#rsSolicitudesDetalle.CFcodigoDet# - #rsSolicitudesDetalle.CFdescripcionDet#
										<cfelse>
										 	---
										</cfif>
                                   	</td>
                                    <td nowrap><cfif Len(Trim(rsSolicitudesDetalle.Doc))>#rsSolicitudesDetalle.Doc#</cfif>&nbsp;<a href='##' onclick='javascript:return fnImprimir(#rsSolicitudesDetalle.ESidsolicitud#,"#rsSolicitudesDetalle.ESnumero#", #rsSolicitudesDetalle.CMSid#);'><img border='0' src='/cfmx/sif/imagenes/impresora2.gif'></td>
								  </tr>
								  <cfset iCount = iCount + 1>
								</cfloop>
							  </table>
							  <!--- Esto es para colocar los checks en forma correcta una vez que entra a la pantalla con items cargados en session --->
							  <script language="javascript" type="text/javascript">
							  	if (document.form1.DSlinea_#solicitud#.value) {
									UpdChkSolicitud(document.form1.DSlinea_#solicitud#);
								} else {
									UpdChkSolicitud(document.form1.DSlinea_#solicitud#[0]);
								}
							  </script>							</td>
						  </tr>
					  </cfloop>
				  <cfelse>
					  <tr>
						<td colspan="6" align="center" nowrap>
							<strong>No existen itemes de compra para iniciar un nuevo proceso de compra</strong>						</td>
					  </tr>
				  </cfif>
				</table>
			</td>
		  </tr>
			
			<tr>
				<td>&nbsp;</td>
			</tr>
			<cfif rsSolicitudes.recordCount GT 10>
				<tr align="center">
					<td colspan="7">
						<cfif ProcesoPublicado>
							<input type="submit" name="btnContinuar" class="btnNormal" value="Continuar >>" onClick="javascript: funcSiguiente();"> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
						<cfelse>
							<input type="submit"  name="btnGuardar"  class="btnGuardar" value="Guardar y Continuar >>" onClick="javascript: funcSiguiente();  return checkContinuar();"><!---  onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
						</cfif>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</cfif>
			  	<tr>
					<td colspan="7">Cantidad de Registros: #rsSolicitudesTodo.recordcount#</td>
				</tr>
		</table>
	</form>
</cfoutput>