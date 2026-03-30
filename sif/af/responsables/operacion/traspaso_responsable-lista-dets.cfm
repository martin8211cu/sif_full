<!--- Funcionalidad Especial El Usuario Funciona como Id del Documento por Falta de ID de Documento. --->
<cf_dbfunction name="now" returnvariable="hoy">
<cfset urlParam="">
<!---Tipo Documento--->
<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
	select b.CRTDid as value,<cf_dbfunction name="concat" args=" rtrim(b.CRTDcodigo) ,'-' ,ltrim(rtrim(b.CRTDdescripcion)) "> as description, 0, b.CRTDcodigo
	   from CRTipoDocumento b
	where b.Ecodigo =  #Session.Ecodigo# 
	union 
	  select -1 as value, '--Todos--' as description, -1, ' ' from dual
	order by 3,4
</cfquery>
<!---Centro Funcional--->
<cfquery name="rsCFuncional" datasource="#Session.DSn#">
	select distinct afr.CFid as value,rtrim(cf.CFcodigo) as description,0, cf.CFcodigo
	  from AFTResponsables aftr
	   inner join AFResponsables afr
		  inner join CFuncional cf
			on cf.CFid = afr.CFid
	   on afr.AFRid = aftr.AFRid
	where aftr.Usucodigo  =  #Session.Usucodigo# 
	  and aftr.AFTRtipo   = 1
	  and aftr.AFTRestado = 30
	union 
		select -1 as value, '--Todos--' as description, -1, ' ' from dual
	order by 3,4
</cfquery>
<!---                   Menejo de Errores                            ---->
<!---   -Traslado desde control de Responsables Pendiente de aplicar ---->
<!---   -Rechazado por el centro de Custodia                         ---->
<!---   -Categori-clase no permitida al centro de custodia destino   ---->
<!---   -Mas de un vale vigente                                      ---->
<cf_dbtemp name="ErrTrasCDR01" returnvariable="Errores" datasource="#session.dsn#">
	<cf_dbtempcol name="Aid"    type="numeric"  mandatory="no">
	<cf_dbtempcol name="error"  type="integer"  mandatory="no">
	<cf_dbtempcol name="error2" type="integer"  mandatory="no">
	<cf_dbtempcol name="error4" type="integer"  mandatory="no">
	<cf_dbtempcol name="error5" type="integer"  mandatory="no">	
	<cf_dbtempcol name="error6" type="integer"  mandatory="no">	
</cf_dbtemp>

<cfquery name="rsReporte" datasource="#Session.Dsn#">
	insert into #Errores#(Aid, error, error2, error4, error5, error6)
		select	act.Aid,
			coalesce ( 	case when exists ( select 1 from AFTResponsables aftr2 where aftr2.AFTRid <> aftr.AFTRid and aftr2.AFRid = aftr.AFRid ) 
							then 1 else 0 
						end 
					,0 ) as error,
			coalesce ( 	case aftr.AFTRestado when 50 
							then 1 else 0 
						end
					, 0 ) as error2,
			coalesce ( 	case when exists (select 1 from CRAClasificacion where CRCCid = aftr.CRCCid and Ecodigo = #session.Ecodigo# ) 
							then 
								case when not exists ( select 1 from CRAClasificacion where CRCCid = aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid  and Ecodigo = #session.Ecodigo#) 
									then 1 
									else 0 
								end
							else 0
						end
					+
						case when exists ( select 1 from CRAClasificacion where CRCCid <> aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid and Ecodigo = #session.Ecodigo# ) 
							then 1 else 0 
						end
					,0 ) as error4,
			coalesce ( 	
					case when exists 
							( select 1 from AFResponsables afr2
							where #hoy# between afr2.AFRfini and afr2.AFRffin
							    and afr2.Aid = afr.Aid                                                            
							group by afr2.Aid 
							having count(1) >1) 
							then 1 else 0 
						end ,0 
					) as error5,
					
			coalesce ( case when exists ( select 1 from TransConsecutivo tr
							where tr.AFTRid  = aftr.AFTRid                                                            
							group by tr.AFTRid 
							having count(1) >0) 
							then 1 else 0 
						end ,0 
					) as error6

	from AFTResponsables aftr
			inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
				and afr.Ecodigo = #Session.Ecodigo#
			inner join Activos act
				on act.Aid = afr.Aid
	where aftr.Usucodigo = #Session.Usucodigo# 
	  and aftr.AFTRtipo = 1 
	  and aftr.AFTRestado in ( 30, 50 )
</cfquery>

<cfif isdefined("form.chkMostrarSoloErrores") and form.chkMostrarSoloErrores>
	<cfquery name="rsErrores" datasource="#Session.Dsn#" >
		delete from #Errores#
		where error  = 0 
		  and error2 = 0 
		  and error4 = 0 
		  and error5 = 0
		  and error6 = 0
	</cfquery>
</cfif>

<cfquery name="rsErrores" datasource="#Session.Dsn#" >
	select coalesce(sum(error),0) as error, 
	       coalesce(sum(error2),0) as error2, 
		   coalesce(sum(error4),0) as error4, 
		   coalesce(sum(error5),0) as error5, 
		   coalesce(sum(error5),0) as error6 
	 from #Errores#
</cfquery>
<cfif isdefined("rsErrores") and rsErrores.error GT 0 and rsErrores.error2 GT 0 and rsErrores.error4 GT 0 and rsErrores.error5 GT 0 and rsErrores.error6 GT 0>
	<cfset AplicarTodosValues = "">
	<cfset AplicarTodosNames = "">
<cfelse>
	<cfset AplicarTodosValues = ",Aplicar Todos">
	<cfset AplicarTodosNames = ",btnAplicarByUsucodigo">
</cfif>
<cfoutput>
<cfflush interval="128">
</cfoutput>

	<cfquery name="rsBoleta" datasource="#session.dsn#">
		select Pvalor as value 
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and Pcodigo = 3800
	</cfquery>

<form action="#CurrentPage#" method="post" name="lista">
	<input type="hidden" name="CPDEmsgrechazo">

<cfif #rsBoleta.value# eq 1>
	<input type="hidden" name="Boleta" value="<cfoutput>#rsBoleta.value#</cfoutput>">
<cfoutput>
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cf_dbfunction name="to_char" args="aftr.AFTRid" returnvariable="LvarAFTRid">
	<cf_dbfunction name="to_char" args="afr.AFRid" returnvariable="LvarAFRid">
	<cf_dbfunction name="concat" args="rtrim(doc.CRTDcodigo) ,'-' ,ltrim(rtrim(doc.CRTDdescripcion))"  returnvariable="CRTD1" >
	<cf_dbfunction name="concat" args="rtrim(crtd.CRTDcodigo),'-' ,ltrim(rtrim(crtd.CRTDdescripcion))" returnvariable="CRTD2" >
	<cf_dbfunction name="concat" args="rtrim(crtd.CRTDcodigo),'-' ,ltrim(rtrim(crtd.CRTDdescripcion))" returnvariable="CRTD2" >
	<cf_dbfunction name="concat" args="DEapellido1 ,' ' , DEnombre" returnvariable="part1">
	<cf_dbfunction name="spart" args="#PreserveSingleQuotes(part1)#,1,20" returnvariable="part2">
	<cf_dbfunction name="concat" args="de.DEidentificacion ; '-' ;#PreserveSingleQuotes(part2)#" returnvariable="DEidentificacionComp" delimiters=";">
	<cf_dbfunction name="spart"   args="act.Adescripcion,1,20" returnvariable="Adescripcion">
	<cf_dbfunction name="to_char" args="aftr.AFTRid" returnvariable="AFTRid">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return PopUperr(""PTR"",1,""'+#PreserveSingleQuotes(AFTRid)#+'"",""'+rtrim(ltrim(act.Aplaca))+'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''></a>&nbsp;'" returnvariable="img1" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(2,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop2.gif''></a>&nbsp;'" returnvariable="img2" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(4,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop4.gif''></a>&nbsp;'" returnvariable="img3" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(5,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop3.gif''>&nbsp;'" returnvariable="img4" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ver('+ #PreserveSingleQuotes(LvarAFTRid)# +',""'+rtrim(act.Aplaca)+'"");''><img src=''/cfmx/sif/imagenes/Printer01_T.gif'' border=''0''></a>'" returnvariable="lvarver" delimiters="+">
	<cf_dbfunction name="to_char" args="tr.TConsecutivo" returnvariable="LvarConsecutivo">
	<cf_dbfunction name="concat" args="'No.'+ ' ' + #LvarConsecutivo#+' '+ '<img border=''0'' src=''/cfmx/sif/imagenes/w-check.gif''>&nbsp;'"  returnvariable="img5" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcAnular(6,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/deletesmall.gif''></a>&nbsp;'" returnvariable="img6" delimiters="+">
</cfoutput>
	<cfinvoke 
		component="sif.Componentes.pListas" 
		method="pLista" 
		returnvariable="Lvar_Lista" 
		columnas="DISTINCT aftr.AFTRid, tr.TConsecutivo,
				case when aftr.CRTDid is null then ( select #CRTD1# 
								from CRTipoDocumento doc
								where doc.CRTDid = afr.CRTDid)
				else #CRTD2# 
				end as CRTipoDocumento,
				act.Aplaca, 
				#PreserveSingleQuotes(Adescripcion)# as Adescripcion, 
				aftr.AFTRfini, 
				((
					select min(cfde.CFcodigo)
					from CFuncional cfde
					where cfde.CFid = afr.CFid
				)) as CFuncional, 
				#PreserveSingleQuotes(DEidentificacionComp)# as DEidentificacionComp, 
				usu.Usulogin,
				case e1.error								    
					when 1 then #PreserveSingleQuotes(img1)#					
					else '&nbsp;'
					end
				as error,				
				case e1.error2
					when 1 then #PreserveSingleQuotes(img2)#
					else '&nbsp;'
					end
				as error2,
				case e1.error4
					when 1 then #PreserveSingleQuotes(img3)#
					else '&nbsp;'
					end
				as error4,
				case e1.error5
					when 1 then #PreserveSingleQuotes(img4)#
					else '&nbsp;'
					end
				as error5,
		
				case when (e1.error + e1.error2 + e1.error4 + e1.error5 ) > 0 then aftr.AFTRid else 0 end as inactivecol,
				
				
				case when (e1.error + e1.error2 + e1.error4 + e1.error5) > 0 then ' ' else #PreserveSingleQuotes(lvarver)# end as ver,				
				
				case e1.error6
					when 1 then #PreserveSingleQuotes(img5)#
					else '&nbsp;'
					end
				as imagen,
				
				case e1.error6
					when 1 then #PreserveSingleQuotes(img6)#
					else '&nbsp;'
					end
				as imagenAnula
				"
		inactivecol="inactivecol"
		tabla=" AFTResponsables aftr
				left outer join TransConsecutivo tr
					on tr.AFTRid  = aftr.AFTRid   				
				inner join Usuario usu
					on usu.Usucodigo = aftr.BMUsucodigo	
				inner join AFResponsables afr
						inner join Activos act
								inner join #errores# e1
								on e1.Aid = act.Aid
							on act.Aid = afr.Aid
						inner join CFuncional cf
						on cf.CFid = afr.CFid
					on afr.AFRid = aftr.AFRid
				inner join DatosEmpleado de
					on de.DEid = aftr.DEid
				left outer join CRTipoDocumento crtd
					on crtd.CRTDid = aftr.CRTDid"
		filtro="aftr.Usucodigo = #Session.Usucodigo# and aftr.AFTRtipo = 1 and aftr.AFTRestado in ( 30, 50 ) order by aftr.AFTRfini"
		desplegar="CRTipoDocumento, Aplaca, Adescripcion, AFTRfini, CFuncional, DEidentificacionComp,Usulogin,imagen, imagenAnula, error, error2, error4,error5, ver"
		etiquetas="Tipo de Documento, Placa, Descripci&oacute;n, Fecha, Centro Funcional, Identificaci&oacute;n, Usuario,Consecutivo,&nbsp;,&nbsp;"
		filtrar_por="case when aftr.CRTDid is null then afr.CRTDid else aftr.CRTDid end, act.Aplaca, act.Adescripcion, aftr.AFTRfini, cf.CFid, de.DEidentificacion,usu.Usulogin,'','', '', '','','',''"
		cortes=""
		maxrows="25"
		formatos="I,S,S,D,I,S,S,G,G,G,G,G,U,U"
		align="left,left,left,left,left,left,left,left,right,rigth,rigth,rigth,left,left"
		mostrar_filtro="true"
		filtrar_automatico="true"
		showemptylistmsg="true"
		rscrtipodocumento="#rsCRTipoDocumento#"
		rscfuncional="#rsCFuncional#"
		emptylistmsg=" --- No se encontraron Documentos --- "
		ira="#CurrentPage#"
		checkboxes="S"
		keys="AFTRid"
		incluyeform="false"
		formname="lista"
		showlink="false"
		ajustar="N"
		/>	
	<cfelse>
	<cfoutput>
	<cf_dbfunction name="concat" args="rtrim(doc.CRTDcodigo) ,'-' ,ltrim(rtrim(doc.CRTDdescripcion))"  returnvariable="CRTD1" >
	<cf_dbfunction name="concat" args="rtrim(crtd.CRTDcodigo),'-' ,ltrim(rtrim(crtd.CRTDdescripcion))" returnvariable="CRTD2" >
	<cf_dbfunction name="concat" args="rtrim(crtd.CRTDcodigo),'-' ,ltrim(rtrim(crtd.CRTDdescripcion))" returnvariable="CRTD2" >
	<cf_dbfunction name="concat" args="DEapellido1 ,' ' , DEnombre" returnvariable="part1">
	<cf_dbfunction name="spart" args="#PreserveSingleQuotes(part1)#,1,20" returnvariable="part2">
	<cf_dbfunction name="concat" args="de.DEidentificacion ; '-' ;#PreserveSingleQuotes(part2)#" returnvariable="DEidentificacionComp" delimiters=";">
	<cf_dbfunction name="spart"   args="act.Adescripcion,1,20" returnvariable="Adescripcion">
	<cf_dbfunction name="to_char" args="aftr.AFTRid" returnvariable="AFTRid">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return PopUperr(""PTR"",1,""'+#PreserveSingleQuotes(AFTRid)#+'"",""'+rtrim(ltrim(act.Aplaca))+'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''></a>&nbsp;'" returnvariable="img1" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(2,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop2.gif''></a>&nbsp;'" returnvariable="img2" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(4,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop4.gif''></a>&nbsp;'" returnvariable="img3" delimiters="+">
	<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(5,'+#PreserveSingleQuotes(AFTRid)#+');''><img border=''0'' src=''/cfmx/sif/imagenes/stop3.gif''>&nbsp;'" returnvariable="img4" delimiters="+">
</cfoutput>
<!---
    <cfinvoke component="sif.Componentes.PlistaControl" method="GetControl" returnvariable="ContList">
        <cfinvokeargument name="SScodigo" value="SIF">
        <cfinvokeargument name="SMcodigo" value="AF">
        <cfinvokeargument name="SPcodigo" value="CRAFOPTR">
        <cfinvokeargument name="default"  value="25">
    </cfinvoke>--->
	<cfinvoke 
		component="sif.Componentes.pListas" 
		method="pLista" 
		returnvariable="Lvar_Lista" 
		columnas="DISTINCT aftr.AFTRid, 
				case when aftr.CRTDid is null then ( select #CRTD1# 
								from CRTipoDocumento doc
								where doc.CRTDid = afr.CRTDid)
				else #CRTD2# 
				end as CRTipoDocumento,
				act.Aplaca, 
				#PreserveSingleQuotes(Adescripcion)# as Adescripcion, 
				aftr.AFTRfini, 
				((
					select min(cfde.CFcodigo)
					from CFuncional cfde
					where cfde.CFid = afr.CFid
				)) as CFuncional, 
				#PreserveSingleQuotes(DEidentificacionComp)# as DEidentificacionComp, 
				usu.Usulogin,
				case e1.error								    
					when 1 then #PreserveSingleQuotes(img1)#					
					else '&nbsp;'
					end
				as error,				
				case e1.error2
					when 1 then #PreserveSingleQuotes(img2)#
					else '&nbsp;'
					end
				as error2,
				case e1.error4
					when 1 then #PreserveSingleQuotes(img3)#
					else '&nbsp;'
					end
				as error4,
				case e1.error5
					when 1 then #PreserveSingleQuotes(img4)#
					else '&nbsp;'
					end
				as error5,
		
				case when (e1.error + e1.error2 + e1.error4 + e1.error5 ) > 0 then aftr.AFTRid else 0 end as inactivecol
				"
		inactivecol="inactivecol"
		tabla=" AFTResponsables aftr
				left outer join TransConsecutivo tr
					on tr.AFTRid  = aftr.AFTRid   				
				inner join Usuario usu
					on usu.Usucodigo = aftr.BMUsucodigo	
				inner join AFResponsables afr
						inner join Activos act
								inner join #errores# e1
								on e1.Aid = act.Aid
							on act.Aid = afr.Aid
						inner join CFuncional cf
						on cf.CFid = afr.CFid
					on afr.AFRid = aftr.AFRid
				inner join DatosEmpleado de
					on de.DEid = aftr.DEid
				left outer join CRTipoDocumento crtd
					on crtd.CRTDid = aftr.CRTDid"
		filtro="aftr.Usucodigo = #Session.Usucodigo# and aftr.AFTRtipo = 1 and aftr.AFTRestado in ( 30, 50 ) order by aftr.AFTRfini"
		desplegar="CRTipoDocumento, Aplaca, Adescripcion, AFTRfini, CFuncional, DEidentificacionComp,Usulogin,error, error2, error4,error5"
		etiquetas="Tipo de Documento, Placa, Descripci&oacute;n, Fecha, Centro Funcional, Identificaci&oacute;n, Usuario"
		filtrar_por="case when aftr.CRTDid is null then afr.CRTDid else aftr.CRTDid end, act.Aplaca, act.Adescripcion, aftr.AFTRfini, cf.CFid, de.DEidentificacion,usu.Usulogin,'', '', '',''"
		cortes=""
		maxrows="25"
		formatos="I,S,S,D,I,S,S,G,G,G,G"
		align="left,left,left,left,left,left,left,right,rigth,rigth,rigth"
		mostrar_filtro="true"
		filtrar_automatico="true"
		showemptylistmsg="true"
		rscrtipodocumento="#rsCRTipoDocumento#"
		rscfuncional="#rsCFuncional#"
		emptylistmsg=" --- No se encontraron Documentos --- "
		ira="#CurrentPage#"
		checkboxes="S"
		keys="AFTRid"
		incluyeform="false"
		formname="lista"
		showlink="false"
		ajustar="N"
		/>	
	</cfif>
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="8%" align="left">&nbsp;</td>
			<td width="82%" align="center">
				<cf_botones values="Eliminar, Eliminar Todos, Aplicar #AplicarTodosValues#"
						names="btnEliminarMasivo, btnEliminarByUsucodigo, btnAplicarMasivo #AplicarTodosNames#">
			</td>
			<td width="8%" align="left">
				<cfif rsErrores.error>
				   <a href="##" onclick="javascript:return funcEliminarError(1);"><img border='0' src='/cfmx/sif/imagenes/deletestop.gif'></a>
				</cfif>
				<cfif rsErrores.error2>
				   <a href="##" onclick="javascript:return funcEliminarError(2);"><img border='0' src='/cfmx/sif/imagenes/deletestop2.gif'></a>
				</cfif>
				<cfif rsErrores.error4>
				   <a href="##" onclick="javascript:return funcEliminarError(4);"><img border='0' src='/cfmx/sif/imagenes/deletestop4.gif'></a>
				</cfif>
				<cfif rsErrores.error5>
				   <a href="##" onclick="javascript:return funcEliminarError(5);"><img border='0' src='/cfmx/sif/imagenes/deletestop3.gif'></a>
				</cfif>
				&nbsp;
			</td>
		</tr>
	</table>	
</form>
	<cfif isdefined("form.Agregar")>
	    <!---Cantidad de activos que cumplian con los filtros pero que no fueron agregados por estan en transaciones pendiente de Activos Fijos--->
		<cfquery name="rsActivoNoAgregados" datasource="#Session.Dsn#">
			 Select count(1) as RSet
			   from AFResponsables
		 	  where Ecodigo =  #Session.Ecodigo# 
			<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
			  and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">
			</cfif>
			  and #hoy# between AFRfini and AFRffin
			  and not exists(select 1
						      from AFTResponsables
						     where AFTResponsables.AFRid = AFResponsables.AFRid
						     and AFTResponsables.Usucodigo =  #Session.Usucodigo# 
						     and AFTResponsables.AFTRtipo = 1 )
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			   and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
			<cfif isdefined("form.Aplacai") and len(trim(form.Aplacai))>
				and exists (select 1
							  from Activos 
							where Activos.Aid = AFResponsables.Aid
							and  Activos.Ecodigo = AFResponsables.Ecodigo
							and Activos.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Aplacai#">)
			</cfif>	
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>		
			<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid))>
				and CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
			</cfif>		
				and exists (Select 1 
							  from ADTProceso ADT 
							 where ADT.Ecodigo = AFResponsables.Ecodigo 
							 and ADT.Aid = AFResponsables.Aid)			
		 </cfquery>
	<!---paso por url al popup--->
		 <cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
			<cfset urlParam =urlParam & "&CRCCid=#form.CRCCid#">   
		</cfif>	
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			<cfset urlParam =urlParam & "&DEid=#form.DEid#">   
		</cfif>	
		<cfif isdefined("form.Aplacai") and len(trim(form.Aplacai))>
			<cfset urlParam =urlParam & "&Aplacai=#form.Aplacai#">   
		</cfif>
		<cfif isdefined("form.CFid") and len(trim(form.CFid))>
			<cfset urlParam =urlParam & "&CFid=#form.CFid#">   
		</cfif>
		<cfif isdefined("form.CRTDid") and len(trim(form.CRTDid)) >
			<cfset urlParam =urlParam & "&CRTDid=#form.CRTDid#">   
		</cfif>

	</cfif>

<cfif rsErrores.error or rsErrores.error2 or  rsErrores.error4 or  rsErrores.error5 or isdefined("form.Agregar")>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
	<tr>
		<td>
			<cfif rsErrores.error>
				<img src="/cfmx/sif/imagenes/stop.gif">&nbsp; Error! El registro se encuentra siendo transferido por otro usuario en este momento. No se puede procesar Registro!<br />
			</cfif>
			<cfif rsErrores.error2>
				<img src="/cfmx/sif/imagenes/stop2.gif">&nbsp; Error! El registro fu&eacute; rechazado por el Centro de Custodia Destino. El Registro puede ser reprocesado!<br />
			</cfif>
			<cfif rsErrores.error4>
				<img src="/cfmx/sif/imagenes/stop4.gif">&nbsp; Error! La Categor&iacute;a / Clase del Documento no esta permitida para el Centro de Custodia destino. No se puede procesar Registro!<br />
			</cfif>
			<cfif rsErrores.error5>
				<img src="/cfmx/sif/imagenes/stop3.gif">&nbsp; Error! Activo Inconsistente, el Activo tienen dos vales vigentes. No se puede procesar Registro!<br />
			</cfif>
			
			 <cfif isdefined("form.Agregar")>
			  <cfif rsActivoNoAgregados.RSet GT 0>
			       <a href="##" onClick="javascript:PopUpAdv();"> 
			          <img border=''0'' src="/cfmx/sif/imagenes/stop4.gif">&nbsp;Advertencia! Algunos Activos cumplen con los filtros seleccionados, pero no fueron agregados ya que est&aacute;n siendo procesados desde Activos Fijos!<br />								
			       </a>
			  </cfif>
			</cfif>
	
		</td>
	</tr>
</table>
</cfif>
<script language="javascript" type="text/javascript">
		function algunoMarcado(){
			var f = document.lista;
			if (f.chk) {
				if (f.chk.checked) {
					return true;
				} else {
					for (var i=0; i<f.chk.length; i++) {
						if (f.chk[i].checked) { 
							return true;
						}
					}
				}
			}
			return false;
		}
		function funcbtnEliminarMasivo(){
			if (algunoMarcado()){
				if (confirm("Desea eliminar los elementos seleccionados?")){
					document.lista.action="traspaso_responsable-sql.cfm";
					return true;
				}
			} else {
				alert("Debe seleccionar los elementos de la lista que desea eliminar!");
			}
			return false;
		}
		function funcbtnEliminarByUsucodigo(){
			if (confirm("Desea eliminar todos los elementos?")){
				document.lista.action="traspaso_responsable-sql.cfm";
				return true;
			}
			return false;
		}
		function funcEliminarError(errornum,aftrid){
			switch (errornum) {
				case 1:
					errormsg = "que se encuentran siendo transferidos por otros usuarios"
					break;
				case 2:
					errormsg = "que se fueron rechazados por el centro de custodia destino"
					break;
				case 3:
					errormsg = "que el Centro Funcional del Documento no se encuentra asociado al Centro Centro de Custodia Destino"
					break;
				case 4:
					errormsg = "que la Categoria / Clase del Documento no se encuentra asociada al Centro Centro de Custodia Destino"
					break;
				case 5:
					errormsg = "donde el Activo tenga dos vales vigentes"
					break;
			}
			if (confirm("Desea eliminar todos los traslados "+errormsg+"?")) {
				if (!aftrid) aftrid = 0;
				document.location.href="traspaso_responsable-sql.cfm?EliminarError=true&errornum="+errornum+"&aftrid="+aftrid;
				document.lista.nosubmit = true;
				return false;
			}
			document.lista.nosubmit = true;
			return false;
		}
		
		function funcAnular(CPDEmsgrechazo,aftrid){
		var vReason = prompt('¿Está seguro(a) de que desea Anular el traslado?, Debe digitar una razón de rechazo!','');
		if (vReason && vReason != ''){
			document.lista.CPDEmsgrechazo.value = vReason;
			document.location.href="traspaso_responsable-sql.cfm?AnularError=true&CPDEmsgrechazo="+vReason+"&aftrid="+aftrid;
			document.lista.nosubmit = true;
			return true;
		}
		if (vReason=='')
			alert('Debe digitar una razón de rechazo!');
		return false;
	}

		function funcbtnAplicarMasivo(){
			if (algunoMarcado()){
				if (confirm("Desea procesar los elementos seleccionados?")){
					document.lista.action="traspaso_responsable-sql.cfm";
					return true;
				}
			} else {
				alert("Debe seleccionar los elementos de la lista que desea procesar!");
			}
			return false;
		}
		function funcbtnAplicarByUsucodigo(){
			if (confirm("Desea procesar todos los elementos?")){
				document.lista.action="traspaso_responsable-sql.cfm";
				return true;
			}
			return false;
		}
		function PopUperr(Pantorigen,Numerr,AFTRid,Placa){
			var PARAM  = "Usrerrors.cfm?err="+Numerr+"&Pantorigen="+Pantorigen+"&AFTRid="+AFTRid+"&Placa="+Placa;
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=350,height=300');
		}	
		function PopUpAdv(){
			var PARAM  = "UsrAdvert.cfm?adv=2<cfoutput>#urlParam#</cfoutput>";
			open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=550,height=300')
		
		}	
</script>

<cfoutput>
<cfif isDefined("Lvar_Lista") and len(trim(Lvar_Lista))>
	<script language="javascript1.2" type="text/javascript">	
		if (#Lvar_Lista# > 500) {
			alert('La consulta retorno mas de 500 registros. Favor detallar mas las condiciones del filtro para dar un mayor rendimiento.');
		}
	
	<cfif #rsBoleta.value# eq 1>
		function ver(LvarAFTRid,LvarAplaca) {
		var PARAM  = "/cfmx/sif/af/responsables/operacion/TraspasoActivosF.cfm?<cfif isdefined ('form.DEid') and len(trim(form.DEid))>DEid=#form.DEid#&</cfif>AFTRid="+ LvarAFTRid<cfif isdefined ('form.DEidT') and len(trim(form.DEidT))>+"&DEidT="+document.lista.DEid.value</cfif>    
		+"&Aplaca="+LvarAplaca;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=500')
	}
	</cfif>

	</script>
</cfif>
</cfoutput>

