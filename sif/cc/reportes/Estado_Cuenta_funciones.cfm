<!--- 
	Creado por: Mauricio Esquivel
	Fecha: 05 de Agosto del 2008
	Motivo: Separar las funciones del Estado de Cuenta para que puedan incluirse en otros informes.

--->

<cffunction name="fnSeleccionarSocios" description="Seleccionar los Socios de Negocio en la tabla temporal" access="private" output="no">
	<!--- Insertar en la tabla temporal los socios que cumplen las condiciones del proceso --->
 	<cfargument name="SNnumero"            required="yes" type="string">
	<cfargument name="SNnumerob2"          required="yes" type="string">
	<cfargument name="chk_cod_Direccion"   required="yes" type="numeric">
	<cfargument name="DEidCobrador"        required="yes" type="numeric">
	<cfargument name="SNCEid"              required="yes" type="numeric">
	<cfargument name="SNCDvalor1"          required="yes" type="string">
	<cfargument name="SNCDvalor2"          required="yes" type="string">
	<cfargument name="nombrequery"         required="no"  type="string" default="rsSocios">
    <cfargument name="id_direccion"        required="no"  type="numeric">

	<cfif Len(trim(arguments.SNnumero)) and Len(trim(arguments.SNnumerob2)) and arguments.SNnumero EQ arguments.SNnumerob2>
		<cfquery name="#arguments.nombrequery#" datasource="#session.DSN#">
			select 
				s.SNcodigo as SNcodigo, s.SNid as SNid, 
				s.SNnumero as SNnumero, 
				<cfif arguments.chk_cod_Direccion neq -1>
					snd.id_direccion as id_direccion, snd.SNDcodigo as SNDcodigo
				<cfelse>
					s.id_direccion as id_direccion, s.SNnumero as SNDcodigo
				</cfif>
				, s.Mcodigo as Mcodigo
                <cfif arguments.nombrequery eq "RSListaSocios">
	                , s.SNnombre, s.SNemail,
                    (select min(DEemail)
                    from DatosEmpleado de
                    where de.DEid = s.DEidCobrador
                    ) as EmailCobrador
				</cfif>
			from SNegocios s
				<cfif arguments.chk_cod_Direccion neq -1>
					inner join SNDirecciones snd
						inner join SNClasificacionSND cs
						 on cs.SNid = snd.SNid
						and cs.id_direccion = snd.id_direccion
					on snd.SNid = s.SNid
					<cfif arguments.DEidCobrador neq -1>
						  and snd.DEidCobrador = #arguments.DEidCobrador#
					</cfif>
				<cfelse>
					inner join SNClasificacionSN cs
					on cs.SNid = s.SNid
				</cfif>

				inner join SNClasificacionD cd
				on cd.SNCDid = cs.SNCDid
				and cd.SNCEid = #arguments.SNCEid#

			where s.Ecodigo = #session.Ecodigo#
			  and s.SNnumero = '#arguments.SNnumero#'
			<cfif arguments.chk_cod_Direccion eq -1 and arguments.DEidCobrador neq -1>
			  and s.DEidCobrador = #arguments.DEidCobrador#
			</cfif>
			  and cd.SNCDvalor between '#arguments.SNCDvalor1#' and '#arguments.SNCDvalor2#'
			<cfif arguments.chk_cod_Direccion neq -1 and isdefined("arguments.id_direccion") and arguments.id_direccion NEQ -1>
				and snd.id_direccion = #arguments.id_direccion#
			<cfelseif isdefined("arguments.id_direccion") and arguments.id_direccion NEQ -1>
            	and s.id_direccion = #arguments.id_direccion#
			</cfif>
			order by cd.SNCDvalor, s.SNnumero <cfif arguments.chk_cod_Direccion neq -1>, snd.SNDcodigo</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="#arguments.nombrequery#" datasource="#session.DSN#">
			select
				s.SNcodigo as SNcodigo, s.SNid as SNid, 
				s.SNnumero as SNnumero, 
				<cfif arguments.chk_cod_Direccion neq -1>
					snd.id_direccion as id_direccion, snd.SNDcodigo as SNDcodigo
				<cfelse>
					s.id_direccion as id_direccion, s.SNnumero as SNDcodigo
				</cfif>
				, s.Mcodigo as Mcodigo
                <cfif arguments.nombrequery eq "RSListaSocios">
	                , s.SNnombre, s.SNemail, 
                    (select min(DEemail)
                    from DatosEmpleado de
                    where de.DEid = s.DEidCobrador
                    ) as EmailCobrador
				</cfif>
			from SNClasificacionD cd <cf_dbforceindex name="PCClasificacionD_02">
				<cfif arguments.chk_cod_Direccion neq -1>
					inner join SNClasificacionSND cs
						on cs.SNCDid = cd.SNCDid
					inner join SNDirecciones snd
					   on cs.SNid = snd.SNid
					  and cs.id_direccion = snd.id_direccion
			
					<cfif arguments.DEidCobrador neq -1>
						  and snd.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEidCobrador#">
					</cfif>
				<cfelse>
					inner join SNClasificacionSN cs <cf_dbforceindex name="FKSNClasificacionSN_01">
						on cs.SNCDid = cd.SNCDid
				</cfif>
							
					inner join SNegocios s <cf_dbforceindex name="AK_KEY_ID_SNEGOCIO">
							on s.SNid = cs.SNid
							<cfif arguments.chk_cod_Direccion eq -1 and arguments.DEidCobrador neq -1>
								and s.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEidCobrador#">
							</cfif>
		
			where  s.Ecodigo = #session.Ecodigo#
              and cd.SNCEid = #arguments.SNCEid#  
			  and (cd.SNCDvalor between '#arguments.SNCDvalor1#' and '#arguments.SNCDvalor2#')
            <cfif arguments.chk_cod_Direccion neq -1 and isdefined("arguments.id_direccion") and arguments.id_direccion NEQ -1>
				and snd.id_direccion = #arguments.id_direccion#
			<cfelseif isdefined("arguments.id_direccion") and arguments.id_direccion NEQ -1>
            	and s.id_direccion = #arguments.id_direccion#
			</cfif>
			<cfif Len(trim(arguments.SNnumero))>
					and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SNnumero#">
			</cfif>
	
			<cfif Len(trim(arguments.SNnumerob2))>
					and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SNnumerob2#">
			</cfif>
			order by cd.SNCDvalor, s.SNnumero <cfif arguments.chk_cod_Direccion neq -1>, snd.SNDcodigo</cfif>
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnSeleccionar1Socios" description="Seleccionar UN unico Socios de Negocio en la tabla temporal" access="private" output="no">
	<!--- Insertar en la tabla temporal los socios que cumplen las condiciones del proceso --->
 	<cfargument name="SNnumero"            required="yes" type="string">
	<cfargument name="SNnumerob2"          required="yes" type="string">
	<cfargument name="chk_cod_Direccion"   required="yes" type="numeric">
	<cfargument name="DEidCobrador"        required="yes" type="numeric">
	<cfargument name="SNCEid"              required="yes" type="numeric">
	<cfargument name="SNCDvalor1"          required="yes" type="string">
	<cfargument name="SNCDvalor2"          required="yes" type="string">

	<cfquery name="rsSocios" datasource="#session.DSN#">
		select 
			s.SNcodigo as SNcodigo, s.SNid as SNid, 
			s.SNnumero as SNnumero, 
			<cfif arguments.chk_cod_Direccion neq -1>
				snd.id_direccion as id_direccion, snd.SNDcodigo as SNDcodigo
			<cfelse>
				s.id_direccion as id_direccion, s.SNnumero as SNDcodigo
			</cfif>
			, s.Mcodigo as Mcodigo
		from SNegocios s
			<cfif arguments.chk_cod_Direccion neq -1>
				inner join SNDirecciones snd
				   on s.SNid         = snd.SNid
				  and s.id_direccion = snd.id_direccion
			</cfif>
		where s.Ecodigo = #session.Ecodigo#
		<cfif Len(trim(arguments.SNnumero)) and Len(trim(arguments.SNnumerob2)) and arguments.SNnumero EQ arguments.SNnumerob2>
			  and s.SNnumero = '#arguments.SNnumero#'
		<cfelse>
			  and s.SNnumero >= '#arguments.SNnumero#'
			  and s.SNnumero <= '#arguments.SNnumerob2#'
		</cfif>
	</cfquery>
</cffunction>


<cffunction name="fnSaldosInicialesMes" access="private" output="no">
	<!--- /* insertar los saldos iniciales del socio */ --->
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">
	
	<cfquery datasource="#session.DSN#">
		insert into #movimientos#
		(
			Ecodigo, Socio, SNnumero, Moneda, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Ocodigo, Control, Reclamo, OrdenCompra, 
			TTransaccion, Documento, Fecha,	
			Total, 
			Pago, TReferencia, DReferencia, Ordenamiento, 
			SNid, TRgroup, Oficodigo, CDCcodigo
		)
		select 
			#arguments.Ecodigo#, #arguments.SNcodigo#, '#arguments.SNnumero#', coalesce(si.Mcodigo, #arguments.Mcodigo#) as Mcodigo, 
			<cfif arguments.chk_cod_Direccion neq -1>
				#arguments.id_direccion#, 
			</cfif>
			-1,	1,'', '', 
			'',' Saldo Inicial', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">,
			coalesce(sum(SIsaldoinicial), 0),
			0,	' ',	' ',	' ',
			#arguments.SNid#, ' ', ' ', 0
		from SNegocios so
		<cfif SaldoCero eq -1>inner<cfelse>left outer</cfif> join SNSaldosIniciales si
			on si.SNid      = so.SNid
			and si.Speriodo = #arguments.periodo#
			and si.Smes     = #arguments.mes#
			<cfif arguments.chk_cod_Direccion neq -1>
			  and si.id_direccion = #arguments.id_direccion#
			</cfif>
		where so.SNid     = #arguments.SNid#
		  and so.Ecodigo  = #arguments.Ecodigo#
		  and so.SNcodigo = #arguments.SNcodigo#
		group by 
			coalesce(si.Mcodigo, #arguments.Mcodigo#)
	</cfquery>

</cffunction>

<cffunction name="fnIncluirDocumentos" access="private" output="no">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<!--- Insertar los los documentos --->
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo, 
			Control,
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)
		select 
			#arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				do.id_direccionFact,
			</cfif>
			do.Dfecha,
			do.CCTcodigo,
			do.Ddocumento,
			#arguments.Ecodigo#, 
			#arguments.SNcodigo#, 
			'#arguments.SNnumero#', 
			do.Mcodigo, 
			do.Ocodigo as Oficina, 
			2 as Control,
			do.DEnumReclamo as Reclamo, 
			do.DEordenCompra as OrdenCompra, 
			case when t.CCTtipo = 'D' then do.Dtotal else -do.Dtotal end as Total,
			0 as Pago,
			do.CCTcodigo as TReferencia,
			do.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			do.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = do.Ecodigo and o.Ocodigo = do.Ocodigo )) as Oficodigo,
			coalesce(do.CDCcodigo, 0) as CDCcodigo,
			do.Dvencimiento
		from HDocumentos do
					inner join CCTransacciones t 
					on t.CCTcodigo = do.CCTcodigo
					and t.Ecodigo = do.Ecodigo

		where do.SNcodigo = #arguments.SNcodigo#
		and   do.Dfecha  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
		and   do.Dfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and	  do.Dfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   do.Ecodigo =  #arguments..Ecodigo#
		<cfif arguments.chk_cod_Direccion neq -1>
			and do.id_direccionFact = #arguments.id_direccion#
		</cfif>
	</cfquery>
</cffunction>

<cffunction name="fnIncluirRecibos" access="private" output="no" description="Recibos de Dinero">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<!--- 
		Cambio:  
		Documentos tipo Credito aplicados a documentos tipo Debito del Socio que se busca, donde el documento que se aplica no exista en HDocumentos 
	--->

	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo, 
			Control,
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)

		select
			#Arguments.SNid# as SNid,
			<cfif arguments.chk_cod_Direccion neq -1>
				#arguments.id_direccion# as IDdireccion,
			</cfif>
			bm.Dfecha as Fecha,
			bm.CCTcodigo as TTransaccion,
			bm.Ddocumento as Documento,
			#arguments.Ecodigo# as Ecodigo, 
			#arguments.SNcodigo# as Socio, 
			'#arguments.SNnumero#' as SNnumero, 
			do.Mcodigo as Moneda, 
			min(do.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(-bm.Dtotalref) as Total,
			1 as Pago,
			min(t.CCTcodigo) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = do.Ecodigo and o.Ocodigo = do.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			bm.Dfecha as FechaVencimiento
		from HDocumentos do
			inner join CCTransacciones t2
			on  t2.Ecodigo    = do.Ecodigo
			and t2.CCTcodigo  = do.CCTcodigo
			and t2.CCTtranneteo = 0

			inner join BMovimientos bm
			on  bm.DRdocumento = do.Ddocumento
			and bm.CCTRcodigo  = do.CCTcodigo
			and bm.Ecodigo     = do.Ecodigo

			inner join CCTransacciones t
			 on t.Ecodigo     = bm.Ecodigo
			and t.CCTcodigo   = bm.CCTcodigo
			and t.CCTtranneteo = 0

			
		where do.Ecodigo   = #Arguments.Ecodigo#
		  and do.SNcodigo  = #Arguments.SNcodigo#
		  and do.Dfecha   <= #Arguments.FechaFin#
		  and t.CCTtipo    = 'C'
		  and t2.CCTtipo   = 'D'
		  and bm.Dfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		<cfif arguments.chk_cod_Direccion neq -1>
		   and do.id_direccionFact = #arguments.id_direccion#
		</cfif>
		  and (( select count(1) 
          		 from HDocumentos d2 
                 where d2.Ecodigo    = bm.Ecodigo 
                   and d2.CCTcodigo  = bm.CCTcodigo 
                   and d2.Ddocumento = bm.Ddocumento )) = 0
		group by 
			bm.Dfecha,
			bm.CCTcodigo,
			bm.Ddocumento,
			do.Mcodigo,
			do.Ecodigo,
			do.Ocodigo
	</cfquery>
</cffunction>

<cffunction name="fnIncluirNCaOtrosSocios" access="private" output="no" description="Notas de Credito del socio aplicadas a documentos de otros socios">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)

		select 
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CCTcodigo,
			'APLIC. ' #_Cat# bm.CCTcodigo #_Cat#  '-' #_Cat# rtrim(bm.Ddocumento) #_Cat# '/' #_Cat# bm.CCTRcodigo #_Cat# '-' #_Cat# ltrim(rtrim(bm.DRdocumento))  as Documento,
			#Arguments.Ecodigo#,
			#Arguments.SNcodigo#,
			'#Arguments.SNnumero#',
			hd.Mcodigo,
			min(hd.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(bm.Dtotal) Total,
			1 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = hd.Ecodigo and o.Ocodigo = hd.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			min(bm.Dfecha) as FechaVencimiento

		from HDocumentos hd
			inner join CCTransacciones t
			on t.CCTcodigo = hd.CCTcodigo
			and t.Ecodigo = hd.Ecodigo

			inner join BMovimientos bm
			on bm.Ecodigo = hd.Ecodigo
			and bm.CCTcodigo = hd.CCTcodigo
			and bm.Ddocumento = hd.Ddocumento
			
			inner join HDocumentos hd2
			on hd2.Ecodigo = bm.Ecodigo
			and hd2.CCTcodigo = bm.CCTRcodigo
			and hd2.Ddocumento = bm.DRdocumento
			
			
		where hd.Ecodigo = #Arguments.Ecodigo#
		  and hd.SNcodigo = #Arguments.SNcodigo#
		  and hd.Dfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		<cfif arguments.chk_cod_Direccion neq -1>
			and hd.id_direccionFact = #Arguments.id_direccion#
		</cfif>
		  and   t.CCTtipo = 'C'
		  and   bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		  and   bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		  and   bm.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		  and   bm.CCTcodigo <> bm.CCTRcodigo
		  and   hd2.SNcodigo  <> hd.SNcodigo						<!--- Socios Diferentes --->
		group by
			bm.CCTcodigo,
			bm.Ddocumento,
			bm.CCTRcodigo,
			bm.DRdocumento,
			hd.Mcodigo,
			hd.Ecodigo,
			hd.Ocodigo
	</cfquery>
</cffunction>

<cffunction name="fnIncluirNCdeOtrosSocios" access="private" output="no" description="Notas de Credito de otros socios aplicadas a documentos del socio del estado de cuenta">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)

		select 
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CCTcodigo,
			'APLIC. ' #_Cat# bm.CCTRcodigo #_Cat#  '-' #_Cat# rtrim(bm.DRdocumento) #_Cat# '/' #_Cat# bm.CCTcodigo #_Cat# '-' #_Cat# ltrim(rtrim(bm.Ddocumento))  as Documento,
			#arguments.Ecodigo#, 
			#arguments.SNcodigo#, 
			'#Arguments.SNnumero#', 
			hd.Mcodigo, 
			min(hd.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(-bm.Dtotal) Total,
			1 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = hd.Ecodigo and o.Ocodigo = hd.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			min(bm.Dfecha) as FechaVencimiento

		from HDocumentos hd
			inner join CCTransacciones t
			on t.CCTcodigo = hd.CCTcodigo
			and t.Ecodigo = hd.Ecodigo

			inner join BMovimientos bm 
				inner join HDocumentos hd2
				on  hd2.Ddocumento = bm.Ddocumento
				and hd2.CCTcodigo  = bm.CCTcodigo
				and hd2.Ecodigo    = bm.Ecodigo

			on  bm.DRdocumento = hd.Ddocumento
			and bm.CCTRcodigo  = hd.CCTcodigo
			and bm.Ecodigo     = hd.Ecodigo

		where hd.SNcodigo = #Arguments.SNcodigo#
		and   hd.Ecodigo  = #Arguments.Ecodigo#
		<cfif arguments.chk_cod_Direccion neq -1>
			and hd.id_direccionFact = #Arguments.id_direccion#
		</cfif>
		and   t.CCTtipo = 'D'										<!--- Solo Documentos Tipo Debito --->
		
		and   bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		and   bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   bm.Ecodigo    =  #Arguments.Ecodigo#
		and   bm.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">

		and   bm.CCTcodigo  <> bm.CCTRcodigo
		and   hd2.SNcodigo  <> hd.SNcodigo   				 		<!---Socios Diferentes--->

		group by
			bm.CCTcodigo,
			bm.CCTRcodigo,
			bm.DRdocumento,
			bm.Ddocumento,
			hd.Mcodigo,
			hd.Ecodigo,
			hd.Ocodigo
	</cfquery>
</cffunction>

<cffunction name="fnIncluirNeteos" access="private" output="no" description="Incluir los Documentos Aplicados en Proceso de Neteo">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)
		select
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(m.Dfecha) as Fecha,
			m.CCTcodigo,
			<cf_dbfunction name="sPart"	args="d.CCTcodigo #_Cat# ' ' #_Cat# rtrim(d.Ddocumento) #_Cat#' (Aplic.Neteo ' #_Cat# rtrim(m.Ddocumento)#_Cat#')';1;50" delimiters=";"> 
			as Documento,
			#Arguments.Ecodigo#, 
			#Arguments.SNcodigo#, 
			'#Arguments.SNnumero#', 
			d.Mcodigo, 
			min(d.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(case when t.CCTtipo = 'D' then m.Dtotal*-1 else m.Dtotal end) as Total,
			1 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			m.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			m.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			min(m.Dfecha) as FechaVencimiento
		from BMovimientos m

			inner join CCTransacciones t
			on  t.Ecodigo   = m.Ecodigo
			and t.CCTcodigo = m.CCTRcodigo

			inner join HDocumentos d 
			on  d.Ddocumento = m.DRdocumento
			and d.CCTcodigo  = m.CCTRcodigo
			and d.Ecodigo    = m.Ecodigo
			and d.SNcodigo   = m.SNcodigo

		where m.SNcodigo   = #Arguments.SNcodigo#
		and   m.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		and   m.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   m.Ecodigo    =  #Arguments.Ecodigo#
		#PreserveSingleQuotes(LvarTransNeteo)#
		and   m.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">

		and   m.CCTcodigo  <> m.CCTRcodigo                  <!--- Solo para transacciones hechas sobre documentos.  Elimino construcción de doctos --->

		<cfif arguments.chk_cod_Direccion neq -1>
			and d.id_direccionFact = #Arguments.id_direccion#
		</cfif>
		group by  
			m.CCTcodigo,
			d.CCTcodigo,
			d.Ddocumento,
			m.Ddocumento,
			d.Mcodigo,
			d.Ecodigo,
			d.Ocodigo
	</cfquery>
</cffunction>

<cffunction name="fnIncluirPagosTes" access="private" output="no" description="Pagos realizados a Notas de Credito del Socio de Negocios.  Pago Tesorería">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)
		select 
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CCTRcodigo,
			rtrim(bm.DRdocumento) #_Cat# ' Pago: ' #_Cat# bm.CCTcodigo #_Cat#  '-' #_Cat# rtrim(bm.Ddocumento)  as Documento,
			#arguments.Ecodigo#, 
			#Arguments.SNcodigo#, 
			'#Arguments.SNnumero#', 
			hd.Mcodigo, 
			min(hd.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(bm.Dtotal) as Total,
			0 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			bm.DRdocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTRcodigo as TRgroup,
			' ' as Oficodigo,
			0 as CDCcodigo,
			min(bm.Dfecha) as FechaVencimiento
		from BMovimientos bm
	
			inner join CCTransacciones t
			on  t.CCTcodigo = bm.CCTRcodigo
			and t.Ecodigo   = bm.Ecodigo
	
			inner join CCTransacciones t2
			on t2.CCTcodigo = bm.CCTcodigo
			and t2.Ecodigo  = bm.Ecodigo
	
			inner join HDocumentos hd
			on hd.CCTcodigo   = bm.CCTcodigo
			and hd.Ddocumento = bm.Ddocumento
			and hd.Ecodigo    = bm.Ecodigo
			and hd.SNcodigo   = bm.SNcodigo
	
		where bm.SNcodigo   = #Arguments.SNcodigo#
		and   bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		and   bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   bm.Ecodigo    =  #Arguments.Ecodigo#
		and   bm.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">

		and   bm.CCTcodigo  <> bm.CCTRcodigo				<!--- Solo para transacciones hechas sobre documentos.  Elimina construcción de doctos --->
		and   bm.CCTRcodigo in ('PC', 'PT')					<!--- Solo pagos realizados desde Tesorería.  No se consideran otros pagos realizados --->
		and   t.CCTcodigo   in ('PC', 'PT')
		and   t.CCTtipo     = 'D'
		and   t.CCTpago     = 0
		and   t2.CCTtipo    = 'C'
		<cfif arguments.chk_cod_Direccion neq -1>
			and hd.id_direccionFact = #Arguments.id_direccion#
		</cfif>
		group by
			bm.CCTRcodigo,
			bm.DRdocumento,
			bm.CCTcodigo,
			bm.Ddocumento,
			hd.Mcodigo
	</cfquery>
</cffunction>

<cffunction name="fnIncluirNCdireccion" access="private" output="no" description="Notas de Credito de un socio aplicadas a otra direccion del mismo socio">
	<cfargument name="Ecodigo"           type="numeric"      required="yes">
	<cfargument name="SNcodigo"          type="numeric"      required="yes">
	<cfargument name="SNid"              type="numeric"      required="yes">
	<cfargument name="FechaIni"          type="date"         required="yes">
	<cfargument name="FechaFin"          type="date"         required="yes">
	<cfargument name="SNnumero"          type="string"      required="yes">
	<cfargument name="periodo"           type="numeric"      required="yes">
	<cfargument name="mes"               type="numeric"      required="yes">
	<cfargument name="id_direccion"      type="numeric"      required="yes">
	<cfargument name="rSNDcodigo"        type="string"      required="yes">
	<cfargument name="Mcodigo"           type="numeric"      required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" required="yes">

	<!--- 
		1. Notas de Credito de un socio aplicadas a otra direccion del mismo socio - Nota de Credito en la Direccion del ciclo
		2. Notas de Credito de un socio aplicadas a otra direccion del mismo socio - Nota de Credito en la otra Direccion del ciclo
	--->

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)
		select 
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CCTcodigo,
			'APLIC. ' #_Cat# bm.CCTcodigo #_Cat#  '-' #_Cat# rtrim(bm.Ddocumento) #_Cat# '/' #_Cat# bm.CCTRcodigo #_Cat# '-' #_Cat# ltrim(rtrim(bm.DRdocumento))  as Documento,
			#Arguments.Ecodigo#, 
			#Arguments.SNcodigo#, 
			'#Arguments.SNnumero#', 
			hd.Mcodigo, 
			min(hd.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(case when t.CCTtipo = 'D' then bm.Dtotal*-1 else bm.Dtotal end) as Total,
			1 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTcodigo as TRgroup,
			((select min(o.Oficodigo) from Oficinas o where o.Ecodigo = hd.Ecodigo and o.Ocodigo = hd.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			min(bm.Dfecha) as FechaVencimiento
		from BMovimientos bm
			inner join CCTransacciones t
			 on t.CCTcodigo = bm.CCTcodigo
			and t.Ecodigo   = bm.Ecodigo

			inner join HDocumentos hd
			on  hd.Ddocumento = bm.Ddocumento
			and hd.CCTcodigo  = bm.CCTcodigo
			and hd.Ecodigo    = bm.Ecodigo
			and hd.SNcodigo   = bm.SNcodigo

			inner join HDocumentos hd2
			on  hd2.Ddocumento  = bm.DRdocumento
			and hd2.CCTcodigo   = bm.CCTRcodigo
			and hd2.Ecodigo     = bm.Ecodigo
			and hd2.SNcodigo    = bm.SNcodigo
	
		where bm.SNcodigo   = #Arguments.SNcodigo#
		and   bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		and   bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   bm.Ecodigo    =  #Arguments.Ecodigo#
		and   bm.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">

		and   bm.CCTcodigo <> bm.CCTRcodigo					<!--- Solo para transacciones hechas sobre documentos.  Eliminar construcción de doctos --->
		and   t.CCTtipo    = 'C'
		<cfif arguments.chk_cod_Direccion neq -1>
			and hd.id_direccionFact = #Arguments.id_direccion#
		</cfif>

		and  hd2.SNcodigo = hd.SNcodigo							<!---Socios iguales--->
		and  hd2.id_direccionFact <> hd.id_direccionFact
		group by
			bm.CCTcodigo,
			bm.Ddocumento,
			bm.CCTRcodigo,
			bm.DRdocumento,
			hd.Mcodigo,
			hd.Ecodigo,
			hd.Ocodigo
	</cfquery>

	<cfquery datasource="#session.DSN#">
		insert into #movimientos# (
			SNid, 
			<cfif arguments.chk_cod_Direccion neq -1>
				IDdireccion, 
			</cfif>
			Fecha,
			TTransaccion,
			Documento,
			Ecodigo, 
			Socio,
			SNnumero, 
			Moneda, 
			Ocodigo,
			Control, 
			Reclamo, 
			OrdenCompra,  
			Total, 
			Pago, 
			TReferencia,
			DReferencia,
			Ordenamiento, 
			TRgroup, 
			Oficodigo, 
			CDCcodigo,
			FechaVencimiento
		)
		select 
			#Arguments.SNid#,
			<cfif arguments.chk_cod_Direccion neq -1>
				#Arguments.id_direccion#,
			</cfif>
			min(bm.Dfecha) as Fecha,
			bm.CCTcodigo,
			'APLIC. ' #_Cat# bm.CCTRcodigo #_Cat#  '-' #_Cat# rtrim(bm.DRdocumento) #_Cat# '/' #_Cat# bm.CCTcodigo #_Cat# '-' #_Cat# ltrim(rtrim(bm.Ddocumento))  as Documento,
			#Arguments.Ecodigo#, 
			#Arguments.SNcodigo#, 
			'#Arguments.SNnumero#', 
			hd.Mcodigo, 
			min(hd.Ocodigo) as Oficina, 
			2 as Control,
			' ' as Reclamo, 
			' ' as OrdenCompra, 
			sum(case when t.CCTtipo = 'D' then bm.Dtotal*-1 else bm.Dtotal end) as Total,
			1 as Pago,
			min(t.CCTdescripcion) as TReferencia,
			bm.Ddocumento as DReferencia,
			' ' as Ordenamiento,
			bm.CCTcodigo as TRgroup,
			(( select min(o.Oficodigo) from Oficinas o where o.Ecodigo = hd.Ecodigo and o.Ocodigo = hd.Ocodigo)) as Oficodigo,
			0 as CDCcodigo,
			min(bm.Dfecha) as FechaVencimiento
		from BMovimientos bm
			inner join CCTransacciones t
			 on t.CCTcodigo = bm.CCTRcodigo
			and t.Ecodigo   = bm.Ecodigo

			inner join HDocumentos hd
			on  hd.Ecodigo         = bm.Ecodigo
			and hd.CCTcodigo       = bm.CCTRcodigo
			and hd.Ddocumento      = bm.DRdocumento
			and hd.SNcodigo        = bm.SNcodigo

			inner join HDocumentos hd2
			on hd2.Ecodigo         = bm.Ecodigo
			and hd2.CCTcodigo      = bm.CCTcodigo
			and hd2.Ddocumento     = bm.Ddocumento
			and hd2.SNcodigo       = bm.SNcodigo

		where bm.SNcodigo   = #Arguments.SNcodigo#
		and   bm.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#">
		and   bm.Dfecha     <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">
		and   bm.Ecodigo    =  #Arguments.Ecodigo#
		and   bm.Dfecha 
				between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaIni#"> 
				    and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaFin#">

		and   bm.CCTcodigo <> bm.CCTRcodigo					<!--- Solo para transacciones hechas sobre documentos.  Eliminar construcción de doctos --->
		and   t.CCTtipo    = 'D'
		<cfif arguments.chk_cod_Direccion neq -1>
			and hd.id_direccionFact = #Arguments.id_direccion#
		</cfif>

		and  hd2.SNcodigo = hd.SNcodigo							<!---Socios iguales--->
		and  hd2.id_direccionFact <> hd.id_direccionFact
		group by
			bm.CCTcodigo,
			bm.Ddocumento,
			bm.CCTRcodigo,
			bm.DRdocumento,
			hd.Mcodigo,
			hd.Ecodigo,
			hd.Ocodigo
	</cfquery>
</cffunction>

<cffunction name="fnObtenerPeriodosAntiguedad" access="private" output="no" hint="Obtener los períodos de antiguedad de saldos para el análisis">
	<cfargument name="FechaFinal" type="date" required="yes">
	<cfset LvarAntiguedad1 = 30>
	<cfset LvarAntiguedad2 = 60>
	<cfset LvarAntiguedad3 = 90>
	<cfset LvarAntiguedad4 = 120>
	<cfset LvarAntiguedad5 = 150>
	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pcodigo as Codigo, Pvalor as Param
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo in (310, 320, 330, 340)
	</cfquery>
	<cfloop query="rs">
		<cfswitch expression="#rs.Codigo#">
            <cfcase value="310"><cfset LvarAntiguedad1 = rs.Param></cfcase>
            <cfcase value="320"><cfset LvarAntiguedad2 = rs.Param></cfcase>
            <cfcase value="330"><cfset LvarAntiguedad3 = rs.Param></cfcase>
            <cfcase value="340"><cfset LvarAntiguedad4 = rs.Param></cfcase>
        </cfswitch>
	</cfloop>
	<cfset LvarAntiguedad5 = LvarAntiguedad4 + 30>
	<cfset LvarFechaAntiguedad1 = dateadd('d', -LvarAntiguedad1, Arguments.FechaFinal)>
	<cfset LvarFechaAntiguedad2 = dateadd('d', -LvarAntiguedad2, Arguments.FechaFinal)>
	<cfset LvarFechaAntiguedad3 = dateadd('d', -LvarAntiguedad3, Arguments.FechaFinal)>
	<cfset LvarFechaAntiguedad4 = dateadd('d', -LvarAntiguedad4, Arguments.FechaFinal)>
	<cfset LvarFechaAntiguedad5 = dateadd('d', -LvarAntiguedad5, Arguments.FechaFinal)>
</cffunction>

<cffunction name="fnSaldosInicialesFechas" access="private" output="no" hint="Obtener los Saldos Iniciales del Socio de Negocios">
	<cfargument name="Ecodigo"           type="numeric"      	required="yes">
	<cfargument name="SNcodigo"          type="numeric"      	required="yes">
	<cfargument name="SNid"              type="numeric"      	required="yes">
	<cfargument name="FechaIni"          type="date"         	required="yes">
	<cfargument name="FechaFin"          type="date"         	required="yes">
	<cfargument name="SNnumero"          type="string"      	required="yes">
	<cfargument name="periodo"           type="numeric"      	required="yes">
	<cfargument name="mes"               type="numeric"      	required="yes">
	<cfargument name="id_direccion"      type="numeric"      	required="yes">
	<cfargument name="rSNDcodigo"        type="string"      	required="yes">
	<cfargument name="Mcodigo"           type="numeric"      	required="yes">
	<cfargument name="chk_cod_Direccion" type="numeric" 		required="yes">
	<cfargument name="FechaInicioMes"    type="date"         	required="yes">

	<cfquery datasource="#session.dsn#">
		delete from #documentos#
	</cfquery>

	<cfquery datasource="#session.DSN#">
		insert into #documentos# (
			Ecodigo, SNid, Socio,  IDdireccion, Documento, TTransaccion,  CCTtipo, Moneda,
			FechaVencimiento, Fecha, Total, SaldoInicial, SaldoFinal)
		select 
			d.Ecodigo, so.SNid, d.SNcodigo, 
			<cfif isdefined("url.chk_cod_Direccion")>
				coalesce(d.id_direccionFact, so.id_direccion),  
			<cfelse>
				so.id_direccion,
			</cfif>
			d.Ddocumento, d.CCTcodigo, t.CCTtipo, d.Mcodigo,
			d.Dvencimiento, d.Dfecha, d.Dtotal as Total, 0.00 as SaldoInicial, d.Dtotal as SaldoFinal
		from HDocumentos d
				inner join CCTransacciones t
				on t.Ecodigo = d.Ecodigo
				and t.CCTcodigo = d.CCTcodigo

				inner join SNegocios so
				on so.Ecodigo = d.Ecodigo
				and so.SNcodigo = d.SNcodigo

		where d.Ecodigo  = #Arguments.Ecodigo#
		  and d.SNcodigo = #Arguments.SNcodigo#
		<cfif arguments.chk_cod_Direccion neq -1>
			  and d.id_direccionFact = #Arguments.id_direccion#
		</cfif>
		  and d.Dfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fechaFin#">
	</cfquery> 

	<!--- 	
		Actualizar el saldo de todos los documentos a la fecha de inicio del análisis.
		Documentos tipo "Debito", se hace el join por las columnas DRdocumento, CCTRcodigo y Ecodigo
	--->

	<cfquery datasource="#session.DSN#">		
		update #documentos#
		set 
			SaldoInicial = 
					case when #documentos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Arguments.fechaIni)#"> 
					then 0.00 
					else 
						#documentos#.Total - 
						coalesce((
							select sum(Dtotalref)
							from BMovimientos bm
							where bm.Ecodigo = #documentos#.Ecodigo
							  and bm.CCTRcodigo = #documentos#.TTransaccion
							  and bm.DRdocumento = #documentos#.Documento
							  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.fechaIni)#">
							  and bm.CCTcodigo <> bm.CCTRcodigo 
						) , 0.00)
					end ,
			SaldoFinal  = #documentos#.Total -
					coalesce((
						select sum(Dtotalref)
						from BMovimientos bm
						where bm.Ecodigo = #documentos#.Ecodigo
						  and bm.CCTRcodigo = #documentos#.TTransaccion
						  and bm.DRdocumento = #documentos#.Documento
						  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fechaFin#">
						  and bm.CCTcodigo <> bm.CCTRcodigo 
					) , 0.00)			
		where #documentos#.CCTtipo = 'D'
	</cfquery>
	
	<!---
		Documentos tipo "Credito", se hace el join por las columnas Ecodigo, CCTcodigo, DDocumento
		Las aplicaciones de los documentos de credito se hacen a documentos de debito - de ahí el join con CCTransacciones t
	--->

	<cfquery datasource="#session.DSN#">
		update #documentos#
		set 
			SaldoInicial = 
					case when #documentos#.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Arguments.fechaIni)#"> 
					then 0.00 
					else 
						#documentos#.Total - 
						coalesce((
							select sum(Dtotalref)
							from BMovimientos bm
								inner join CCTransacciones t
								on t.Ecodigo = bm.Ecodigo
								and t.CCTcodigo = bm.CCTRcodigo
							where bm.Ecodigo = #documentos#.Ecodigo
							  and bm.CCTcodigo = #documentos#.TTransaccion
							  and bm.Ddocumento = #documentos#.Documento
							  and bm.Dfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.fechaIni)#">
							  and bm.CCTcodigo <> bm.CCTRcodigo 
							  and t.CCTtranneteo = 0
							  and t.CCTtipo = 'D' 
							) , 0.00)
					end,
			SaldoFinal = Total - 
					coalesce((
						select sum(Dtotalref)
						from BMovimientos bm
							inner join CCTransacciones t
							on t.Ecodigo = bm.Ecodigo
							and t.CCTcodigo = bm.CCTRcodigo
						where bm.Ecodigo    = #documentos#.Ecodigo
						  and bm.CCTcodigo  = #documentos#.TTransaccion
						  and bm.Ddocumento = #documentos#.Documento
						  and bm.Dfecha     < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fechaFin#">
						  and bm.CCTcodigo  <> bm.CCTRcodigo 
						  and t.CCTtranneteo = 0
						  and t.CCTtipo = 'D' 
						) , 0.00)
		where #documentos#.CCTtipo = 'C'
	</cfquery>

	<!--- Actualizar los neteos de documentos tipo credito que se graban al revés en BMovimientos --->
	<cfquery name="rsUpdateSaldos" datasource="#session.DSN#">
		update #documentos#
		set 
			SaldoInicial = SaldoInicial - coalesce((
				select sum(Dtotalref)
				from BMovimientos bm
					inner join CCTransacciones tt
						on tt.Ecodigo = bm.Ecodigo
						and tt.CCTcodigo = bm.CCTcodigo
				where bm.Ecodigo      = #documentos#.Ecodigo
				  and bm.CCTRcodigo   = #documentos#.TTransaccion
				  and bm.DRdocumento  = #documentos#.Documento
				  and bm.Dfecha       <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fechaIni#">
				  and bm.CCTcodigo    <> bm.CCTRcodigo 
				  and tt.CCTtranneteo = 1
				) , 0.00),
			SaldoFinal = SaldoFinal - coalesce((
				select sum(Dtotalref)
				from BMovimientos bm
					inner join CCTransacciones tt
						on tt.Ecodigo = bm.Ecodigo
						and tt.CCTcodigo = bm.CCTcodigo
				where bm.Ecodigo      = #documentos#.Ecodigo
				  and bm.CCTRcodigo   = #documentos#.TTransaccion
				  and bm.DRdocumento  = #documentos#.Documento
				  and bm.Dfecha       <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fechaFin#">
				  and bm.CCTcodigo    <> bm.CCTRcodigo 
				  and tt.CCTtranneteo = 1
				) , 0.00)
		where #documentos#.CCTtipo = 'C'
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete from #documentos#
		where SaldoInicial = 0.00 and SaldoFinal = 0.00
	</cfquery>
	

	<cfquery datasource="#session.dsn#">
		update #documentos#
		set Total = -Total, SaldoInicial = -SaldoInicial, SaldoFinal = -SaldoFinal
		where CCTtipo = 'C'
	</cfquery>

	<cfset SISaldoInicial = 0.00>
	<cfset SISaldoFinal = 0.00>
	<cfset SIsinvencer = 0.00>
	<cfset SIcorriente = 0.00>
	<cfset SIp1 = 0.00>
	<cfset SIp2 = 0.00>
	<cfset SIp3 = 0.00>
	<cfset SIp4 = 0.00>
	<cfset SIp5 = 0.00>
	<cfset SIp5p = 0.00>

	<cfquery name="rs" datasource="#session.dsn#">
		select Moneda,
			sum(coalesce(SaldoInicial,0)) as SISaldoInicial,
			sum(coalesce(SaldoFinal,0)) as SISaldoFinal,
			sum(case when FechaVencimiento >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin#"> and Fecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaInicioMes#"> then SaldoFinal else 0.00 end) as SIsinvencer,
			sum(case when FechaVencimiento >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin#"> and Fecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaInicioMes#"> then SaldoFinal else 0.00 end) as SIcorriente,
			sum(case when FechaVencimiento <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin#"> and FechaVencimiento > #LvarFechaAntiguedad1# then SaldoFinal else 0.00 end) as SIp1,
			sum(case when FechaVencimiento <  #LvarFechaAntiguedad1# and FechaVencimiento > #LvarFechaAntiguedad2# then SaldoFinal else 0.00 end) as SIp2,
			sum(case when FechaVencimiento <  #LvarFechaAntiguedad2# and FechaVencimiento > #LvarFechaAntiguedad3# then SaldoFinal else 0.00 end) as SIp3,
			sum(case when FechaVencimiento <  #LvarFechaAntiguedad3# and FechaVencimiento > #LvarFechaAntiguedad4# then SaldoFinal else 0.00 end) as SIp4,
			sum(case when FechaVencimiento <  #LvarFechaAntiguedad4# and FechaVencimiento > #LvarFechaAntiguedad5# then SaldoFinal else 0.00 end) as SIp5,
			sum(case when FechaVencimiento <  #LvarFechaAntiguedad5# then SaldoFinal else 0.00 end) as SIp5p
		from #documentos#
		group by Moneda
	</cfquery>
	<cfif rs.recordcount eq 0>
		<cfquery datasource="#session.DSN#">
			insert into #movimientos#
				(
					Ecodigo, Socio, SNnumero, Moneda, 
					<cfif arguments.chk_cod_Direccion neq -1>
									IDdireccion, 
					</cfif>
					Ocodigo, Control, Reclamo, OrdenCompra, 
					TTransaccion, Documento, Fecha,            
					Total, 
					Pago, TReferencia, DReferencia, Ordenamiento, 
					SNid, TRgroup, Oficodigo, CDCcodigo
				)
			select 
					#arguments.Ecodigo#, #arguments.SNcodigo#, '#arguments.SNnumero#', #arguments.Mcodigo# as Mcodigo, 
					<cfif arguments.chk_cod_Direccion neq -1>
									#arguments.id_direccion#, 
					</cfif>
					-1,           1,'', '', 
					'',' Saldo Inicial', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d', -1, arguments.FechaIni)#">,
					0,
					0,            ' ',            ' ',            ' ',
					#arguments.SNid#, ' ', ' ', 0
				from SNegocios so
				where so.SNid     = #arguments.SNid#
				  and so.Ecodigo  = #arguments.Ecodigo#
				  and so.SNcodigo = #arguments.SNcodigo#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #SaldosIniciales# ( 
				Ecodigo, Mcodigo, SNid, id_direccion, 
				SfechaIni, SfechaFin,
				SIsI, SIsaldoFinal, SIsinvencer, SIcorriente, 
				SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p)
			values (
				#arguments.Ecodigo#, #arguments.Mcodigo#, #arguments.SNid#, #arguments.id_direccion#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaIni#">, <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaFin#">,
				0, 0, 0, 0,
				0, 0, 0, 0, 0, 0
				)
		</cfquery>
	 	
	</cfif>
    
	<cfloop query="rs">
		<cfset LvarMcodigo = rs.Moneda>
    	<cfif len(trim(rs.SISaldoInicial))>
			<cfset SISaldoInicial = rs.SISaldoInicial>
        <cfelse>
        	<cfset SISaldoInicial = 0>
        </cfif>
        <cfif len(trim(rs.SISaldoFinal))>
			<cfset SISaldoFinal = rs.SISaldoFinal>
        <cfelse>
        	<cfset SISaldoFinal = 0>
		</cfif>
        <cfif len(trim(rs.SIsinvencer))>
			<cfset SIsinvencer = rs.SIsinvencer>
        <cfelse>
        	<cfset SIsinvencer = 0>
		</cfif>
        <cfif len(trim(rs.SIcorriente))>
			<cfset SIcorriente = rs.SIcorriente>
        <cfelse>
        	<cfset SIcorriente = 0>
		</cfif>
        <cfif len(trim(rs.SIp1))>
			<cfset SIp1 = rs.SIp1>
        <cfelse>
        	<cfset SIp1 = 0>
		</cfif>
        <cfif len(trim(rs.SIp2))>
			<cfset SIp2 = rs.SIp2>
        <cfelse>
        	<cfset SIp2 = 0>
		</cfif>
        <cfif len(trim(rs.SIp3))>
			<cfset SIp3 = rs.SIp3>
        <cfelse>
        	<cfset SIp3 = 0>
		</cfif>
        <cfif len(trim(rs.SIp4))>
			<cfset SIp4 = rs.SIp4>
        <cfelse>
        	<cfset SIp4 = 0>
		</cfif>
        <cfif len(trim(rs.SIp5))>
			<cfset SIp5 = rs.SIp5>
        <cfelse>
        	<cfset SIp5 = 0>
		</cfif>
        <cfif len(trim(rs.SIp5p))>
			<cfset SIp5p = rs.SIp5p>
        <cfelse>
        	<cfset SIp5p = 0>
		</cfif>
		<cfquery datasource="#session.DSN#">
			insert into #movimientos#
				(
					Ecodigo, Socio, SNnumero, Moneda, 
					<cfif arguments.chk_cod_Direccion neq -1>
									IDdireccion, 
					</cfif>
					Ocodigo, Control, Reclamo, OrdenCompra, 
					TTransaccion, Documento, Fecha,            
					Total, 
					Pago, TReferencia, DReferencia, Ordenamiento, 
					SNid, TRgroup, Oficodigo, CDCcodigo
				)
			select 
					#arguments.Ecodigo#, #arguments.SNcodigo#, '#arguments.SNnumero#', #LvarMcodigo# as Mcodigo, 
					<cfif arguments.chk_cod_Direccion neq -1>
									#arguments.id_direccion#, 
					</cfif>
					-1,           1,'', '', 
					'',' Saldo Inicial', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d', -1, arguments.FechaIni)#">,
					#SISaldoInicial#,
					0,            ' ',            ' ',            ' ',
					#arguments.SNid#, ' ', ' ', 0
				from SNegocios so
				where so.SNid     = #arguments.SNid#
				  and so.Ecodigo  = #arguments.Ecodigo#
				  and so.SNcodigo = #arguments.SNcodigo#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #SaldosIniciales# ( 
				Ecodigo, Mcodigo, SNid, id_direccion, 
				SfechaIni, SfechaFin,
				SIsI, SIsaldoFinal, SIsinvencer, SIcorriente, 
				SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p)
			values (
				#arguments.Ecodigo#, #LvarMcodigo#, #arguments.SNid#, #arguments.id_direccion#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaIni#">, <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaFin#">,
				#SISaldoInicial#, #SISaldoFinal#, #SIsinvencer#, #SIcorriente#,
				#SIp1#, #SIp2#, #SIp3#, #SIp4#, #SIp5#, #SIp5p#
				)
		</cfquery>
	</cfloop>	
</cffunction>

<cffunction name="fnObtenerTransaccionesNeteo" access="private" output="no" returntype="string" hint="Obtener los códigos de transacción para los Neteos">	
	<cfset LvarTransNeteo = "">
	<cfquery name="rsTranNeteo" datasource="#session.dsn#">
		select CCTcodigo
		from  CCTransacciones tn
		where tn.Ecodigo      = #session.Ecodigo#
		and tn.CCTtranneteo = 1
	</cfquery>
	<cfif rsTranNeteo.recordcount EQ 1>
		<cfset LvarTransNeteo = "and m.CCTcodigo = '#rsTranNeteo.CCTcodigo#'">
	<cfelseif rsTranNeteo.recordcount GT 1>
		<cfloop query="rsTranNeteo">
			<cfset LvarTransNeteo = trim(LvarTransNeteo) & ", '#rsTranNeteo.CCTcodigo#'">
		</cfloop>
		<cfset LvarTransNeteo = "and m.CCTcodigo in (" & trim(mid(LvarTransNeteo, 3, 255)) & ")">
	</cfif>
</cffunction>


<cffunction name="BorraTemporales" access="private" output="no">
	<cfargument name="socios" required="yes">
	<cfargument name="movimientos" required="yes">

	<cfquery datasource="#session.dsn#">
		delete from #socios#
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete from #movimientos#
	</cfquery>

</cffunction>

<cffunction name="CreaTemp1" access="private" returntype="string" output="no">
	<!--- Tabla de Trabajo de los Socios seleccionados --->
	<cf_dbtemp name="CCsoc01" returnvariable="socios" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"	  	type="integer"	mandatory="no">
		<cf_dbtempcol name="SNcodigo"	  	type="integer"	mandatory="no">
		<cf_dbtempcol name="id_direccion" 	type="numeric"	mandatory="no">
		<cf_dbtempcol name="SNid"			type="numeric"	mandatory="no">
		<cf_dbtempcol name="FechaIni"		type="date"		mandatory="no">
		<cf_dbtempcol name="FechaFin"		type="date"		mandatory="no">
		<cf_dbtempcol name="SNnumero"		type="char(20)"	mandatory="no">
		<cf_dbtempcol name="SNDcodigo"		type="char(20)"	mandatory="no">
		<cf_dbtempcol name="periodo"		type="integer"	mandatory="no">
		<cf_dbtempcol name="mes"			type="integer"	mandatory="no">
		<cf_dbtempcol name='Mcodigo'		type="numeric"	mandatory="yes">
	</cf_dbtemp>
	<cfreturn socios>
</cffunction>

<cffunction name="CreaTemp2" access="private" output="no" returntype="string">
	<cf_dbtemp name="CCmov_v3" returnvariable="movimientos" datasource="#session.dsn#">
		<cf_dbtempcol name="id"  				type="numeric" 		mandatory="no" identity>
		<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNnumero"  			type="char(20)" 	mandatory="no">		
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cfif isdefined("chk_cod_Direccion")>
			<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		</cfif>
		<cf_dbtempcol name="Ocodigo"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="Control"   			type="integer"  	mandatory="no">
		<cf_dbtempcol name="Reclamo"  			type="varchar(20)" 	mandatory="no">
		<cf_dbtempcol name="OrdenCompra"  		type="varchar(20)" 	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(250)" 	mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">		
		<cf_dbtempcol name="Pago"				type="integer" 		mandatory="no">
		<cf_dbtempcol name="TReferencia"		type="char(80)" 		mandatory="no">
		<cf_dbtempcol name="DReferencia"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="Ordenamiento"		type="char(20)" 	mandatory="no">
		<cf_dbtempcol name="SNid"				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="TRgroup"			type="char(2)"		mandatory="no">
		<cf_dbtempcol name="Oficodigo"			type="char(10)"		mandatory="no">
		<cf_dbtempcol name="CDCcodigo"			type="numeric"		mandatory="no">
		<cf_dbtempkey cols="id">
	</cf_dbtemp>
	<cfreturn movimientos>
</cffunction>

<cffunction name="CreaTemp3" access="private" output="no" returntype="string">
	<cf_dbtemp name="CCdoc03" returnvariable="documentos" datasource="#session.dsn#">
		<cf_dbtempcol name="id"  				type="numeric" 		mandatory="yes" identity>
		<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="SNid"	  			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Socio"  			type="integer"	 	mandatory="no">
		<cf_dbtempcol name="IDdireccion"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="Documento" 			type="char(50)" 	mandatory="no">
		<cf_dbtempcol name="TTransaccion"		type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="CCTtipo"			type="char(2)" 		mandatory="no">
		<cf_dbtempcol name="Moneda"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="FechaVencimiento"	type="datetime"		mandatory="no">
		<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
		<cf_dbtempcol name="Total"				type="money"		mandatory="no">		
		<cf_dbtempcol name="SaldoInicial"		type="money"		mandatory="no">		
		<cf_dbtempcol name="SaldoFinal"			type="money"		mandatory="no">		
		<cf_dbtempkey cols="id">
	</cf_dbtemp>
	<cfreturn documentos>
</cffunction>

<cffunction name="CreaTemp4" access="public" output="yes" returntype="string">
	<!--- Generacion de Saldos Iniciales--->
	<cf_dbtemp name="SaldosIniciales" returnvariable="SaldosIniciales" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"  		type="integer" 		mandatory="no">
		<cf_dbtempcol name="Mcodigo"  		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SNid"  			type="numeric" 		mandatory="no">
		<cf_dbtempcol name="id_direccion"  	type="numeric" 		mandatory="no">
		<cf_dbtempcol name="SfechaIni" 		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SfechaFin"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="SIsI"     		type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsaldoFinal"   type="money" 		mandatory="no">
		<cf_dbtempcol name="SIsinvencer"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIcorriente"  	type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp1"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp2"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp3"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp4"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5"  			type="money" 		mandatory="no">
		<cf_dbtempcol name="SIp5p"  		type="money" 		mandatory="no">
	</cf_dbtemp>
    <cfreturn SaldosIniciales>
</cffunction>

