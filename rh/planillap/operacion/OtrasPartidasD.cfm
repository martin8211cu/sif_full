<cfif isdefined('url.RHEid') and not isdefined('form.RHEid')>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined('url.RHOPid') and not isdefined('form.RHOPid')>
	<cfset form.RHOPid = url.RHOPid>
</cfif>
<!--- CONSULTAS --->
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfset rsMeses = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsMeses,13)>
<cfset querySetCell(rsMeses,"value",1,1)>
<cfset querySetCell(rsMeses,"description","Enero",1)>
<cfset querySetCell(rsMeses,"value",2,2)>
<cfset querySetCell(rsMeses,"description","Febrero",2)>
<cfset querySetCell(rsMeses,"value",3,3)>
<cfset querySetCell(rsMeses,"description","Marzo",3)>
<cfset querySetCell(rsMeses,"value",4,4)>
<cfset querySetCell(rsMeses,"description","Abril",4)>
<cfset querySetCell(rsMeses,"value",5,5)>
<cfset querySetCell(rsMeses,"description","Mayo",5)>
<cfset querySetCell(rsMeses,"value",6,6)>
<cfset querySetCell(rsMeses,"description","Junio",6)>
<cfset querySetCell(rsMeses,"value",7,7)>
<cfset querySetCell(rsMeses,"description","Julio",7)>
<cfset querySetCell(rsMeses,"value",8,8)>
<cfset querySetCell(rsMeses,"description","Agosto",8)>
<cfset querySetCell(rsMeses,"value",9,9)>
<cfset querySetCell(rsMeses,"description","Setiembre",9)>
<cfset querySetCell(rsMeses,"value",10,10)>
<cfset querySetCell(rsMeses,"description","Octubre",10)>
<cfset querySetCell(rsMeses,"value",11,11)>
<cfset querySetCell(rsMeses,"description","Noviembre",11)>
<cfset querySetCell(rsMeses,"value",12,12)>
<cfset querySetCell(rsMeses,"description","Diciembre",12)>
<cfset querySetCell(rsMeses,"value",'',13)>
<cfset querySetCell(rsMeses,"description","",13)>
<!---  FIN DE CONSULTAS--->

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formDetallePartidas" method="post" action="OtrasPartidas-sql.cfm">
	<input name="RHEid" type="hidden" value="<cfoutput>#form.RHEid#</cfoutput>" />
	<input name="RHOPid" type="hidden" value="<cfoutput>#form.RHOPid#</cfoutput>" />
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>				
		<td colspan="3">
			<cfset navegacion = ''>
			<cfif isdefined("Form.fperiodo") and len(trim(form.fperiodo))>
				<cfset navegacion = navegacion & "&fperiodo=#form.fperiodo#">
			</cfif>
			<cfif isdefined("Form.mesFiltro") and len(trim(form.mesFiltro))>
				<cfset navegacion = navegacion & "&mesFiltro=#form.mesFiltro#">
			</cfif>
			<!---Cargar el filtro---->
			<cfset vs_filtro= "otp.RHOPid = #form.RHOPid#">
			<cfquery name="rsPartida" datasource="#session.dsn#">
				select coalesce(pop.RHPOPdistribucionCF,0) as xCF
				from RHOtrasPartidas op
					inner join RHPOtrasPartidas pop
						on pop.RHPOPid = op.RHPOPid
				where op.RHOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPid#">
			</cfquery>
			<cfif rsPartida.xCF>
				<cfset lvarEtiquetas="Centro Funcional, Período, Mes , Monto">
				<cfset lvarDesplegar="CentroFuncional, Periodo, descMes, Monto">
				<cfset lvarAlign="rigth,left,left,right">
				<cfset lvarFormatos="S,S,S,M">
				<cfset lvarOrderBy = "otp.CFid,otp.Periodo,otp.Mes">
			<cfelse>
				<cfset lvarEtiquetas="Período, Mes , Monto">
				<cfset lvarDesplegar="Periodo, descMes, Monto">
				<cfset lvarAlign="left,left,right">
				<cfset lvarFormatos="S,S,M">
				<cfset lvarOrderBy = "otp.Periodo,otp.Mes">
			</cfif>
			<cf_dbfunction name="concat" args="cf.CFcodigo,' - ',cf.CFdescripcion" returnvariable="Lvar_CF">
			<cfinvoke 
				component="rh.Componentes.pListas" 
				method="pListaRH"
				returnvariable="rsLista"
				columnas="case otp.Mes 	when 1 then 'Enero'
											when 2 then 'Febrero'
											when 3 then 'Marzo'
											when 4 then 'Abril'
											when 5 then 'Mayo'
											when 6 then 'Junio'
											when 7 then 'Julio'
											when 8 then 'Agosto'
											when 9 then 'Setiembre'
											when 10 then 'Octubre'
											when 11 then 'Noviembre'
											when 12 then 'Diciembre'
							end as descMes,				
							otp.Periodo,
							otp.Monto,
							otp.Mes,#form.RHEid# as RHEid,#form.RHOPid# as RHOPidL, otp.CFid, #Lvar_CF# as CentroFuncional"
				tabla="RHDOtrasPartidas otp left outer join CFuncional cf on cf.CFid = otp.CFid"
				keys="RHOPidL,Mes,Periodo"
				botones="Eliminar"
				checkboxes="s"
				filtro="#vs_filtro# order by #lvarOrderBy#"														
				etiquetas="#lvarEtiquetas#"
				desplegar="#lvarDesplegar#"								
				align="#lvarAlign#"					
				formatos="#lvarFormatos#"
				ira=""
				maxrows="6"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="#Lvar_CF#,otp.Periodo,otp.Mes,otp.Monto"
				showemptylistmsg="true"
				incluyeform="false"
				formName="formDetallePartidas"
				navegacion="RHEid=#form.RHEid#&RHOPid=#form.RHOPid#"
				rsdescMes="#rsMeses#"	
				showlink="false"			
			/>											
		</td>
	</tr>
</table>
</form>
<script>
	function funcEliminar(){
		if ( confirm('Desea eliminar el registro?') ){
			return true;
		}else{
			return false;
		}
	}
</script>