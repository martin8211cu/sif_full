
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp>


<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name#
</cfquery>



<cfif rsImportador.recordcount GT 0>

<cfset currentrow=0>
    <cfloop query="rsImportador">
    	<cfset currentrow=currentrow+1>

    <!--- Tipo de Compra --->

    <cfquery name="rsVerificaCompra" datasource="#session.DSN#">

    select CRTCid, CRTCcodigo, CRTCdescripcion 
    	from CRTipoCompra  
		where CRTCcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.CRTDid)#">
    	
	</cfquery>

	<!---Empleado --->
	 <cfquery name="rsVerificaEmpleado" datasource="#session.DSN#">

		 select DEidentificacion from DatosEmpleado
		WHERe DEidentificacion  = #rsImportador.DEid#

	</cfquery>

	<!---Codigo Empleado --->

	<cfquery name="rsVerificaCodEmpleado" datasource="#session.DSN#">
	
		select d.DEid,d.DEidentificacion, {fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombrecompleto, 
		cf.CFid,cf.CFcodigo,cf.CFdescripcion
	 from CRCCCFuncionales cr
	  inner join CFuncional cf on cf.CFid = cr.CFid 
	  inner join EmpleadoCFuncional decf on decf.CFid = cf.CFid and getdate() between decf.ECFdesde and decf.ECFhasta 
	  inner join DatosEmpleado d on d.DEid = decf.DEid where d.DEidentificacion = #rsImportador.DEid#
 	   order by DEidentificacion
		
	</cfquery>
    <!--- Categoria --->

    <cfquery name="rsVerificaCategoria" datasource="#session.DSN#">
    	select  ACcodigodesc, ACdescripcion,ACcodigo from ACategoria
		where   ACcodigodesc =rtrim(ltrim('#rsImportador.ACcodigo#'))

	</cfquery>

	<!--- Clase --->
	<cfquery name="rsVerificaClase" datasource="#session.DSN#">
	select  
		ACcodigodesc, ACdescripcion,ACid 
			from AClasificacion
		where ACcodigodesc = rtrim(ltrim('#rsImportador.ACid#'))
		 order by 1   

	</cfquery>

	<!---- Marca --->

	<cfquery name="rsVerificaMarca" datasource="#session.DSN#">
	
		select AFMid, AFMcodigo, AFMdescripcion 
			from AFMarcas 
	where AFMdescripcion =  ltrim(rtrim('#rsImportador.AFMid#'))  order by 1  
  
	</cfquery>
	<!--- Modelo --->


	<cfquery name="rsVerificaModelo" datasource="#session.DSN#">
	
		select AFMMid, AFMMcodigo, AFMMdescripcion 
			from AFMModelos 
		where AFMMdescripcion =ltrim(rtrim('#rsImportador.AFMMid#'))
  
	</cfquery>

	<!--- Placa --->


	<cfquery name="rsValidaDuplicadosPlaca" datasource="#session.DSN#">
		 SELECT  *
		   FROM #table_name#
		  where CRDRplaca <> ''
		    and rtrim(upper(CRDRplaca)) = upper('#rsImportador.CRDRplaca#')
	</cfquery>



	<cfquery name="rsValidaDuplicadosPlacaTBL" datasource="#session.DSN#">

	select CRDRplaca,1 as contador from  CRDocumentoResponsabilidad 
	where  upper(CRDRplaca) = upper('#rsImportador.CRDRplaca#') 

	</cfquery>


	<cfquery name="rsValidaDocumento" datasource="#session.DSN#">
	select CRDRdocori,1 as contador from  CRDocumentoResponsabilidad 
	where  upper(CRDRdocori) = upper('#rsImportador.CRDRdocori#')
	and  DDlineas = #rsImportador.Linea#

	</cfquery>
	

		<!-- Incia levantamiento de errores encontrados  -->

		<cfif rsVerificaCompra.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El tipo de Compra (#rsImportador.CRTDid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>


		<cfif rsVerificaEmpleado.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El  Empleado (#rsImportador.DEid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>


		<cfif rsVerificaCodEmpleado.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El codigo del Empleado (#rsImportador.CFid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>

		
		<cfif rsVerificaCategoria.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. La categoria (#rsImportador.ACcodigo#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>

		<cfif rsVerificaClase.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. la Clase  (#rsImportador.ACid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>

		<cfif rsVerificaMarca.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. la Marca  (#rsImportador.AFMid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>


		<cfif rsVerificaModelo.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El modelo (#rsImportador.AFMMid#) no existe en la entidad de la base de datos, el error fue localizado en la linea #currentrow#!')
			</cfquery>
		</cfif>
	
		<!--- <cfif rsValidaDuplicadosPlaca.recordcount gt 0 &&  trim(rsValidaDuplicadosPlaca.contador) gt 1 > --->
		<cfif rsValidaDuplicadosPlaca.recordcount gt 1 >
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. La Placa que desea ingresar, ya existe en la entidad de la base de datos en el registro error en la linea #currentrow#!')
			</cfquery>
		</cfif>
		<cfquery name="rsErrores1" datasource="#session.DSN#">
				select *
				from #errores#
		</cfquery>


		<cfif rsValidaDuplicadosPlacaTBL.recordcount gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error.Error. Debe ingresar una placa diferente en el registro error en la linea  #currentrow#!')
			</cfquery>
		</cfif>

		<cfif rsValidaDocumento.recordcount gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error.Error. La factura de ingreso ya existe con ese numero de linea de detalle, en la linea #currentrow#!')
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

		<cfquery name="rsErrores" datasource="#session.DSN#">
				select *
				from #errores#
		</cfquery>
		<cfif rsErrores.recordcount GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				select Error as MSG
				from #errores#
				group by Error
			</cfquery>
			<cfreturn>
		<cfelse>
			<cftransaction>
				<cfloop query="rsImportador">

					<!---tipo de compra --->

					<cfquery name="rsVerificaCompra" datasource="#session.DSN#">

					    select CRTCid, CRTCcodigo, CRTCdescripcion 
					    	from CRTipoCompra  
						where CRTCcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsImportador.CRTDid)#">
					    	
					</cfquery>

					<cfset CRTCid = #rsVerificaCompra.CRTCid#>

					<!---Empleado --->
					 <cfquery name="rsVerificaEmpleado" datasource="#session.DSN#">

						 select DEid,DEidentificacion from DatosEmpleado
						WHERe DEidentificacion  = #rsImportador.DEid#

					</cfquery>

					<cfset DEIDiN =#rsVerificaEmpleado.DEid#>



					<!---Codigo Empleado --->

					<cfquery name="rsVerificaCodEmpleado" datasource="#session.DSN#">
					
						select cf.CFid,d.DEid,d.DEidentificacion, {fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombrecompleto, 
						cf.CFid,cf.CFcodigo,cf.CFdescripcion
					 from CRCCCFuncionales cr
					  inner join CFuncional cf on cf.CFid = cr.CFid 
					  inner join EmpleadoCFuncional decf on decf.CFid = cf.CFid and getdate() between decf.ECFdesde and decf.ECFhasta 
					  inner join DatosEmpleado d on d.DEid = decf.DEid where d.DEidentificacion = #rsImportador.DEid#
				 	   order by DEidentificacion
						
					</cfquery>

					<cfset CFID = #rsVerificaCodEmpleado.CFid#>

				    <!--- Categoria --->

				    <cfquery name="rsVerificaCategoria" datasource="#session.DSN#">
				    	select  ACcodigodesc, ACdescripcion,ACcodigo from ACategoria
						where   ACcodigodesc =rtrim(ltrim('#rsImportador.ACcodigo#'))

					</cfquery>

					<cfset ACcodigoID = #rsVerificaCategoria.ACcodigo#>

					<!--- Clase --->
					<cfquery name="rsVerificaClase" datasource="#session.DSN#">
					select  
						ACcodigodesc, ACdescripcion,ACid 
							from AClasificacion
						where ACcodigodesc = rtrim(ltrim('#rsImportador.ACid#'))
						 order by 1   

					</cfquery>

					<cfset ACidID = #rsVerificaClase.ACid#>


					<!---- Marca --->

					<cfquery name="rsVerificaMarca" datasource="#session.DSN#">
					
					select AFMid, AFMcodigo, AFMdescripcion 
						from AFMarcas 
					where AFMdescripcion =  ltrim(rtrim('#rsImportador.AFMid#'))  order by 1  
				  
					</cfquery>

					<cfset AFMidID = #rsVerificaMarca.AFMid#>


					<!--- Modelo --->


					<cfquery name="rsVerificaModelo" datasource="#session.DSN#">
					
						select AFMMid, AFMMcodigo, AFMMdescripcion 
							from AFMModelos 
						where AFMMdescripcion =ltrim(rtrim('#rsImportador.AFMMid#'))
				  
					</cfquery>


						<cfset AFMMidID = #rsVerificaModelo.AFMMid#>

					<!--- Placa --->


					<!--- Descripcion y Descripcion Detallada --->


					<cfquery name="rsValidaDesc" datasource="#session.DSN#">

					select CRDRplaca,CRDRdescripcion,CRDRdescdetallada
						from  CRDocumentoResponsabilidad 
					where CRDRdescripcion = rtrim(ltrim('#rsImportador.CRDRdescripcion#'))
					</cfquery>

					<cfquery name="rsValidaDescdetl" datasource="#session.DSN#">

					select CRDRplaca,CRDRdescripcion,CRDRdescdetallada,CRDRfdocumento
						from  CRDocumentoResponsabilidad 
					where CRDRdescdetallada = rtrim(ltrim('#rsImportador.CRDRdescdetallada#'))

					</cfquery>


					<!--- Fecha DOC --->

					<cfquery name="rsFecha" datasource="#session.DSN#">

					select CRDRfdocumento
						from  CRDocumentoResponsabilidad 
					where CRDRfdocumento = rtrim(ltrim('#rsImportador.CRDRfdocumento#'))

					</cfquery>


			
					<!--- documento --->

					<cfquery name="rstipodocm" datasource="#session.DSN#">
					select AFCcodigo, AFCcodigoclas, AFCdescripcion 
						from AFClasificaciones 
						where AFCcodigoclas = rtrim(ltrim('#rsImportador.AFCcodigo#'))   
						order by AFCcodigo 

					</cfquery>

					<cfset AFCcodigoID = #rstipodocm.AFCcodigo#>



					<cfquery name="setupID" datasource ="#Session.DSN#">

					select ( convert(varchar,isnull (max(DDlineas),0) +1))  AS Concecutivo
					FROM CRDocumentoResponsabilidad
					where CRDRdocori = '#rsImportador.CRDRdocori#'
					and Ecodigo = #session.Ecodigo#
					
					</cfquery>


					<cfset LienaConcecutiva =#setupID.Concecutivo#>





					<cfquery datasource="#session.dsn#">
					insert into CRDocumentoResponsabilidad
						(
							Ecodigo,
							CRTDid,
							DEid,
							CFid,
							ACcodigo,
							ACid,
							CRCCid,
							AFMid,
							AFMMid,
							CRDRplaca,
							CRDRdescripcion,
							CRDRdescdetallada,
							CRDRfdocumento,
							CRTCid,
							AFCcodigo,
							CRDRdocori,
							CRDRfalta,
							BMUsucodigo,
							CRDRestado,
							CRDRserie,
							Monto,
							CRDRutilaux,
							CRorigen,
							DDlineas,
							AFCMid,
							AFCMejora,
							CRDRconsecutivo
						
						)
						values
						(
							#SESSION.Ecodigo#,
							#CRTCid#,
							#DEIDiN#,
							#CFID#,
							#ACcodigoID#,
							#ACidID#,
							 1,
							#AFMidID#,
							#AFMMidID#,
							'#rsImportador.CRDRplaca#',
							'#rsImportador.CRDRdescripcion#',
							'#rsImportador.CRDRdescdetallada#',
							'#rsImportador.CRDRfdocumento#',
							 1,
							#AFCcodigoID#,
							'#rsImportador.CRDRdocori#',	
							 getdate(),
							#Session.Usucodigo#,
							 0,
							'#rsImportador.CRDRserie#',
							#rsImportador.Monto#,
							 0,
							 1,
							 #rsImportador.Linea#,
							 -1,
							 0,
							 #LienaConcecutiva#
					)

					</cfquery>

				</cfloop>
    	<cftransaction action="commit"/>
 	</cftransaction>
 </cfif>


























































































































