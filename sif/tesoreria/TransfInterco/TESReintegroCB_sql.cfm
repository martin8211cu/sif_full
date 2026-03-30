<!---<cfdump var="#url#">
<cf_dump var="#form#">	--->
<cfif isdefined('form.CBid')>
	<cfset LvarCBid= ListFirst(form.CBid)>
</cfif>	
<cfset LvarCBidOri= "">
<cfset LvarMiso4217Ori= "">
<cfif isdefined('form.CBidOri') and len(trim(#form.CBidOri#)) gt 0>
	<cfset LvarCBidOri= ListFirst(form.CBidOri)>
	<cfset LvarMiso4217Ori= ListGetAt(form.CBidOri,3)>
</cfif>	

<!---                                  Agregar                                           --->
<cfif isdefined ('form.Agregar')>

	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="rsMaxNum" datasource="#session.dsn#">
			select coalesce(MAX(TESRnumero),0)+1 as numero from  TESreintegro
		</cfquery>
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into TESreintegro(
				TESRnumero,      
				CBid,            
				TESRdescripcion, 
				TESRmonto,    
				TESRestado,   
				BMUsucodigo,
				CBidOri,
				TESid 
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsMaxNum.numero#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarCBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.descrip#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="0">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="0">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarCBidOri#" null="#Len(LvarCBidOri) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#">
			)
		</cfquery>
	</cflock>
	
	<cflocation url="TESReintegroCB.cfm?TESRnumero=#rsMaxNum.numero#">
</cfif>

<!---                                  Regresar                                           --->
<cfif isdefined ('form.Regresar')>
	<cflocation url="TESReintegroCB.cfm">
</cfif>

<!---                                  Limpiar                                           --->
<cfif isdefined ('form.Limpiar')>
	<cflocation url="TESReintegroCB.cfm?Nuevo=nuevo">
</cfif>

<!---                                  Limpiar                                           --->
<cfif isdefined ('form.Imprimir')>
	<cflocation url="TESReintegroCB_rep.cfm?TESRnumero=#form.TESRnumero#&LvarCBid=#form.CBidDst#">
</cfif>



<!---                                  Borrar Linea2                                      --->
<cfif isdefined ('form.btnElimina')>
	<cfif not isdefined ('form.eli') or len(trim(form.eli)) eq 0>
		<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
	</cfif>
	<cfloop list="#form.eli#" delimiters="," index="Lvar">
		<cfset LvarTESDPid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				delete from TESreintegroDet where TESDPid=#LvarTESDPid#
		</cfquery>
	</cfloop>
	
	<cfset updateMonto(#form.TESRnumero#)>
	<cflocation url="TESReintegroCB.cfm?TESRnumero=#form.TESRnumero#">
</cfif>


<!---                                  Agregar Linea2                                      --->
<cfif isdefined ('form.btnAgrega')>
	<cfif not isdefined ('form.agr') or len(trim(form.agr)) eq 0>
		<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
	</cfif>
	<cfloop list="#form.agr#" delimiters="," index="Lvar">
		<cfset LvarTESDPid=#listgetat(Lvar, 1, ',')#>	
		<cfquery name="rsUpRe" datasource="#session.dsn#">
				insert into TESreintegroDet (TESRnumero,TESDPid,BMUsucodigo )
				values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarTESDPid#">,
				#session.Usucodigo#)
		</cfquery>
	</cfloop>
	<cfset updateMonto(#form.TESRnumero#)>
	<cflocation url="TESReintegroCB.cfm?TESRnumero=#form.TESRnumero#">
</cfif>

<!---                                  Nuevo                                            --->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="TESReintegroCB.cfm?Nuevo=1">
</cfif>

<!---                                  Eliminar                                          --->
<cfif isdefined ('form.Eliminar')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESRestado from TESreintegro where TESRnumero=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">
	</cfquery>
	
	<cfif rsSQL.TESRestado eq 0><!---EN PROCESO--->
		<cfquery name="dl1" datasource="#session.dsn#">
			delete  from TESreintegroDet where TESRnumero=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">
		</cfquery>
		<cfquery name="dl1" datasource="#session.dsn#">
			delete  from TESreintegro where TESRnumero=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">
		</cfquery>
	<cfelse>
		<cf_errorCode	code = "50732" msg = "No se puede eliminar una transacción que tiene estado diferente a 'EN PROCESO'">
	</cfif>
	<cflocation url="TESReintegroCB.cfm">
</cfif>

<!---                                  Modificar                                          --->
<cfif isdefined ('form.Modificar')>
	<cfquery name="rsUpRe" datasource="#session.dsn#">
		update TESreintegro set 
			TESRdescripcion	=<cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.descrip#">,
		 	CBidOri			=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarCBidOri#"		null="#LvarCBidOri EQ ""#">,
		 	TESMPcodigoOri	=<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESMPcodigo#"	null="#form.TESMPcodigo EQ ""#">,
		 	TESRtcOri		=
				<cfif LvarMiso4217Ori EQ form.Miso4217Loc>
					1
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_float"	value="#form.TESRtcOri#"	null="#form.TESRtcOri EQ ""#">
				</cfif>
		where TESRnumero	=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">
	</cfquery>
	<cflocation url="TESReintegroCB.cfm?TESRnumero=#form.TESRnumero#">
</cfif>



<!---                                GenerarOP                                             --->
<cfif isdefined ('form.GenerarOP') OR isdefined ('form.ManualTF')>

	<cfset LvarOri = listToArray(form.CBidOri)>
	<cfset LvarDst = listToArray(form.CBid)>

	<cftransaction>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into TEStransfIntercomL 
				(TESid, TESTILtipo, TESTILfecha, TESTILdescripcion, UsucodigoGenera, TESTILfechaGenera,TESTILestado, BMUsucodigo)<!--- TESTILaplicado---> 
			values 
				(
					 #session.Tesoreria.TESid#
					<cfif #LvarOri[2]# eq #LvarDst[2]#>
						,0  <!---Transferencias internas--->
					<cfelse>
						,1  <!---Transferencias Externas--->
					</cfif>
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="Proceso de Reintegro Num. #form.TESRnumero#: #form.descrip#">
					,#session.Usucodigo#
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				<cfif isdefined ('form.GenerarOP')>
					,10 <!---En preparacion--->
				<cfelse>
					,0  <!---Registro manual--->
				</cfif>
					,#session.Usucodigo#
				)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">

		<cfset LvarTESTILid = insert.identity >
		
		<cfquery  datasource="#Session.DSN#">			  
			insert into TEStransfIntercomD 
				(TESid, TESTILid, TESTIDdocumento, TESTIDreferencia,
				 TESTIDdescripcion, 
				 CBidOri, EcodigoOri, Miso4217Ori, TESMPcodigo,
				 TESTIDmontoOri, TESTIDcomisionOri, TESTIDtipoCambioOri, 
				 CBidDst, EcodigoDst, Miso4217Dst, 
				 TESTIDmontoDst, TESTIDtipoCambioDst, 
				 BMUsucodigo
				)
			values (
				 #session.Tesoreria.TESid#
				,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarTESTILid#">
				,<cfqueryparam cfsqltype="cf_sql_char"    	value="#form.TESRnumero#"> 
				,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="Reintegro"> 
				,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="Proceso de Reintegro Num. #form.TESRnumero#: #form.descrip#" null="#trim(form.descrip) EQ ''#">
				
				,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarOri[1]#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarOri[2]#">
				,<cfqueryparam cfsqltype="cf_sql_char" 		value="#LvarOri[3]#">
				,<cfqueryparam cfsqltype="cf_sql_char" 		value="#form.TESMPcodigo#">
				
				,<cfqueryparam cfsqltype="cf_sql_money"   	value="#Replace(form.montoA,',','','all')#">
				,<cfqueryparam cfsqltype="cf_sql_money"  	value="0">
				,<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.TESRtcOri,',','','all')#"> 
	
				,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarDst[1]#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarDst[2]#">
				,<cfqueryparam cfsqltype="cf_sql_char" 		value="#LvarDst[3]#">
				
				,<cfqueryparam cfsqltype="cf_sql_money"   	value="#Replace(form.montoA,',','','all')#">
				,<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.TESRtcOri,',','','all')#">
				,#session.Usucodigo# 
				)
		</cfquery>
		
		
		<cfquery name="rsUpRe" datasource="#session.dsn#">
			update TESreintegro set 
				<cfif isdefined ('form.GenerarOP')>
					TESRestado=11,
				<cfelse>
					TESRestado=1,
				</cfif>
				TESTILid=#LvarTESTILid#
			where TESRnumero	=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.TESRnumero#">
		</cfquery>	
	
		<cfif isdefined ('form.GenerarOP')>
			<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion" 
						method="sbGeneraOP_TransferenciasCB"
						returnVariable = "LvarOP"
			>
				<cfinvokeargument name="TESTILid" value="#LvarTESTILid#"/>
			</cfinvoke>
		</cfif>
	</cftransaction>
	<cfif isdefined ('form.GenerarOP')>
		<cflocation url="TESReintegroCB.cfm?OPnum=#LvarOP#">
	<cfelse>
		<cflocation url="TESReintegroCB.cfm?TESTILid=#LvarTESTILid#">
	</cfif>
</cfif>

<cffunction name="updateMonto" access="private">
<cfargument name="TESRnumero" type="numeric" required="yes"> 
	<cfquery name="monto" datasource="#session.dsn#">
		select coalesce(sum (tdp.TESDPmontoPago),0)  as total
			from  TESdetallePago tdp
			inner join TESreintegroDet d
				on d.TESDPid=tdp.TESDPid
			where tdp.EcodigoOri=#session.Ecodigo#
			and  tdp.TESDPestado in(12,212)
			and d.TESRnumero=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.TESRnumero#">
	</cfquery>		
	
	
	<cfquery datasource="#session.dsn#">
		update TESreintegro set TESRmonto=#monto.total#
			where TESRnumero=<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.TESRnumero#">
	</cfquery>
</cffunction>





