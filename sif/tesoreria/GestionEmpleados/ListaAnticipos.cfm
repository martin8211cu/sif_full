	<cfif isdefined("LvarSAporEmpleadoSQL") and len(trim(LvarSAporEmpleadoSQL)) gt 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			from UsuarioReferencia
			where Usucodigo= #session.Usucodigo#
			and Ecodigo      = #session.EcodigoSDC#
			and STabla        = 'DatosEmpleado'
		</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "50740" msg = "El usuario no ha sido registrado como Empleado de la Empresa">
			</cfif>
	</cfif>
		
<cfquery name="rsAnticipo" datasource="#session.dsn#">

	select a.GEAid,a.GEAnumero,a.Mcodigo,a.TESBid,a.GEAtotalOri,a.GEAdescripcion,b.TESBeneficiario,m.Miso4217,a.GEAtipoP,a.CFid,a.GEAmanual,a.CCHid, 1 as Anti,a.GEAviatico,a.GEAtipoviatico,
		case a.GEAtipoviatico
			when '1' then 'Interior'
			when '2' then 'Exterior'
			else 'N/A'
		end as Viatico
	from GEanticipo a
	inner join TESbeneficiario b
	on a.TESBid=b.TESBid
	inner join Monedas m
	on a.Mcodigo=m.Mcodigo
	where 
		 a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.GEAestado	= 4  <!--- DEBE SER 4=Pagado --->
			
				and (				<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
						(
							select count(1)
							  from GEliquidacionAnts d
								inner join GEliquidacion e
								 on e.GELid 		= d.GELid
								and e.GELestado 	in (0,1,2,4,5)
							<!-----	and e.TESBid = b.TESBid--->
							 where d.GEAid = a.GEAid
						) <
						(
							select count(1)
							  from GEanticipoDet f
							 where f.GEAid = a.GEAid
							   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
						) 
				)
	<cfif isdefined("LvarSAporEmpleadoSQL") and len(trim(LvarSAporEmpleadoSQL)) gt 0>
	 	and b.DEid=#rsSQL.DEid#
	</cfif>
	<cfif isdefined ('form.FILTRO_TESBENEFICIARIO') and len(trim(form.FILTRO_TESBENEFICIARIO)) GT 0>
		and b.TESBeneficiario like '%#form.FILTRO_TESBENEFICIARIO#%'
	</cfif>
	<cfif isdefined ('form.Filtro_GEAnumero') and len(trim(form.Filtro_GEAnumero))>
		and GEAnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#ltrim(form.Filtro_GEAnumero)#">
	</cfif>
	<cfif isdefined ('form.Filtro_GEAdescripcion') and len(trim(form.Filtro_GEAdescripcion))>
		and GEAdescripcion like '%#form.Filtro_GEAdescripcion#%'
	</cfif>
	<cfif isdefined ('form.Filtro_GEAtotalOri') and len(trim(form.Filtro_GEAtotalOri))>
		and GEAtotalOri like '%#form.Filtro_GEAtotalOri#%'
	</cfif>
	<cfif isdefined ('form.Filtro_Miso4217') and len(trim(form.Filtro_Miso4217))>
		and Miso4217 like '%#form.Filtro_Miso4217#%'
	</cfif>
</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
	query="#rsAnticipo#"
	desplegar="GEAnumero,TESBeneficiario,GEAdescripcion,Viatico,GEAtotalOri,Miso4217"
	etiquetas="N°Anticipo,Empleado,Descripción,Viatico,Total,Moneda"
	formatos="S,S,S,S,M,S"
	align="left,left,left,center,right,left"
	ira="LiquidacionAnticipos_sql.cfm?Anticipos=1&tipo=#LvarSAporEmpleadoSQL#"
	form_method="post"	
	showEmptyListMsg="yes"
	keys="GEAid"
	incluyeForm="yes"
	formName="formReintegro"
	PageIndex="3"
	MaxRows="23"	
	navegacion=""
	botones="Regresar,Lista"
	mostrar_filtro="true"
	filtrar_por="GEAnumero,TESBeneficiario,GEAdescripcion,GEAtotalOri,Miso4217"
	/>
	
	


