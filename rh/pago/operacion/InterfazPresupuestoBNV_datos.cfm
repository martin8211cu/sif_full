<cfoutput>

<!--- genera la tabla de los calculos--->
<cf_dbtemp name="TMP_Presupuestos_BNV" returnvariable="TMPCalculos" datasource="#session.DSN#">
   <cf_dbtempcol name="RCNid"  			type="numeric"	mandatory="no">
   <cf_dbtempcol name="CIid"  			type="numeric"	mandatory="no">
   <cf_dbtempcol name="Tipo"  			type="varchar(10)"	mandatory="no">
   
   <cf_dbtempcol name="MontoBase"  		type="money"	mandatory="no">
   
   <cf_dbtempcol name="Total_Renta"  	type="money"	mandatory="no">
   <cf_dbtempcol name="Total_Asevital"  type="money"	mandatory="no">
   <cf_dbtempcol name="Total_CCSS1"  	type="money"	mandatory="no">
   <cf_dbtempcol name="Total_CCSS8"  	type="money"	mandatory="no">
   <cf_dbtempcol name="Total_liquido"  	type="money"	mandatory="no">
   
   <cf_dbtempcol name="porcentaje"  	type="float"	mandatory="no">
   <cf_dbtempcol name="Renta"  			type="money"	mandatory="no">
   <cf_dbtempcol name="Asevital"  		type="money"	mandatory="no">
   <cf_dbtempcol name="CCSS1"  			type="money"	mandatory="no">
   <cf_dbtempcol name="CCSS8"  			type="money"	mandatory="no">
   <cf_dbtempcol name="liquido"  		type="money"	mandatory="no">
</cf_dbtemp>

<!--- Salario Bruto--->
<cfquery  datasource="#session.DSN#">
	Insert into #TMPCalculos# (RCNid,CIid,tipo,MontoBase)
	select RCNid,1,'CS',sum(SEsalarioBruto)
	from hSalarioEmpleado where RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	group by RCNid,1,'CS'
</cfquery>

<!--- Incidencias--->
<cfquery  datasource="#session.DSN#">
	Insert into #TMPCalculos# (RCNid,CIid,tipo,MontoBase)
	select  a.RCNid,a.CIid,'I',sum(a.ICmontores)
	from hIncidenciascalculo a 
	inner join CIncidentes b
	on a.CIid= b.CIid
	and b.CInocargas = 0 
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	group by  a.RCNid,a.CIid,'I'
</cfquery>

<!--- Incidencias a excluir del total del salario liquido--->
<cfquery  datasource="#session.DSN#" name="rsInExcl">
	select coalesce(sum(a.ICmontores),0) as monto
	from hIncidenciascalculo a 
	inner join CIncidentes b
	on a.CIid= b.CIid
	and b.CInocargas = 1 
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
</cfquery>

<!--- Renta Total --->
<cfquery  datasource="#session.DSN#">
	Update #TMPCalculos# 
	set Total_Renta = (select coalesce(sum(a.SErenta),0) from hSalarioEmpleado a where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">) 
		,Total_Asevital=(select coalesce(sum(a.CCvalorEmp),0)
								from hCargasCalculo a 
								inner join DCargas b
								on a.DClinea = b.DClinea
								where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
								and b.DClinea = 15 --Asevital
						)
		,Total_CCSS1= (select coalesce(sum(a.CCvalorEmp),0)
								from hCargasCalculo a 
								inner join DCargas b
								on a.DClinea = b.DClinea
								where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
								and b.DClinea = 3 --BP CCSS 1%
						)
		,Total_CCSS8= (select coalesce(sum(a.CCvalorEmp),0)
								from hCargasCalculo a 
								inner join DCargas b
								on a.DClinea = b.DClinea
								where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
								and b.DClinea = 1 --BP CCSS 8%
						)
		,Total_liquido= 
							(select coalesce(sum(SEliquido),0)- <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInExcl.monto#"> from hSalarioEmpleado 
							where RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">)
						
						
</cfquery>


<!--- Porcentajes --->
<cfquery  datasource="#session.DSN#">
	Update #TMPCalculos#
	set porcentaje= (select x.MontoBase /(select sum(a.MontoBase) from #TMPCalculos# a) 
					 from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)
</cfquery>

<cfquery  datasource="#session.DSN#">
	Update #TMPCalculos#
	set Renta = (select x.porcentaje * x.Total_Renta 
				from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)
		,Asevital = (select x.porcentaje * x.Total_Asevital 
				from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)
		,CCSS1 = (select x.porcentaje * x.Total_CCSS1 
				from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)
		,CCSS8 = (select x.porcentaje * x.Total_CCSS8 
				from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)	
		,liquido = (select x.porcentaje * x.Total_liquido 
				from #TMPCalculos# x where x.tipo= #TMPCalculos#.tipo and x.CIid= #TMPCalculos#.CIid)	
				
</cfquery>

<cfquery datasource="#session.DSN#" name="rstemp">
	select b.CIdescripcion,a.* from 
	#TMPCalculos# a
	inner join CIncidentes b
	on a.CIid = b.CIid
</cfquery>

<!---
<cf_dumptable var="#TMPCalculos#">
<cf_dump var="#rstemp#">
--->

<!--- llenado la estructura PRE_INTERFAZ_BNV--->
<cfquery datasource="#session.DSN#" name="rsCargas">
	select 
		a.DClinea as id,
		b.DCcuentapext as cod_egreso,
		sum(a.CCvalorEmp) as monto,
		<!--- b.DCdescripcion as descripcion, --->
		b.DCcodigoExt as cod_articulo,
		b.DCdescripcion as desc_articulo
	from hCargasCalculo a
	inner join DCargas b
	on b.DClinea = a.DClinea
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and a.CCvalorEmp > 0
	and a.DClinea not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="15,3,1">)
	group by a.DClinea,b.DCcuentapext,b.DCcodigoExt,b.DCdescripcion
	
	UNION
	
	select 
		a.DClinea as id,
		b.DCcuentapext as cod_egreso,
		sum(a.CCvalorPat) as monto,
		<!--- b.DCdescripcion,--->
		b.DCcodigoExt as cod_articulo,
		b.DCdescripcion as desc_articulo
	from hCargasCalculo a
	inner join DCargas b
	on b.DClinea = a.DClinea
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and a.CCvalorPat > 0
	and a.DClinea not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="15,3,1">)
	group by a.DClinea,b.DCcuentapext,b.DCcodigoExt,b.DCdescripcion 
</cfquery>

<cfquery datasource="#session.DSN#" name="rsDeducciones">
	select 
		 x.TDid as id, 
		 b.TDcuentapext as cod_egreso,
	      sum(a.DCValor) as monto,
		  b.TDcodigoExt as cod_articulo,
		 b.TDdescripcion as desc_articulo
	  from hDeduccionesCalculo a
	  inner join DeduccionesEmpleado x
	  on a.Did = x.Did
	  inner join TDeduccion b
	  on b.TDid = x.TDid
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	group by x.TDid, b.TDcodigoExt, b.TDcuentapext, b.TDdescripcion
</cfquery>

<cfquery datasource="#session.DSN#" name="rsIncidencias">
	 select 
	 		a.CIid as id, b.CInorenta as noRenta,b.CInocargas as noCarga, 
	 		b.CIcuentapext as cod_egreso,
	        
	 		sum(a.ICMontores) as monto,
	        b.CIcodigoExt as cod_articulo,
	        b.CIdescripcion as desc_articulo
	    from HIncidenciascalculo a
	    inner join CIncidentes b
	    on b.CIid = a.CIid
	  where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	  group by a.CIid, b.CInorenta,b.CInocargas,b.CIcodigoExt, b.CIcuentapext,b.CIdescripcion
</cfquery>

<!--- se solicita la cuenta para el salario Liquido--->
<cfquery datasource="#session.DSN#" name="rsSalarioLiquido">
select sum(SEliquido) as monto from HSalarioEmpleado where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
</cfquery>
<!--- se solicita la cuenta para renta--->
<cfquery datasource="#session.DSN#" name="rsRenta">
 select sum(SErenta) as monto from hSalarioEmpleado where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
</cfquery>
<!--- se solicita la cuenta para salario Base--->
<cfquery datasource="#session.DSN#" name="rsSalarioBase">
 select sum(SEsalariobruto) as monto from HSalarioEmpleado where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
</cfquery>


<!--- Inicio de Inserts --->
<cftransaction>

<cfquery datasource="sifinterfaces">
	Delete PRE_INTERFAZ_PRESUPUESTO
</cfquery>

<!---
<cfquery datasource="sifinterfaces">
	Insert into PRE_INTERFAZ_PRESUPUESTO(
		NUMERO_INTERFASE,
	    TIPO,
	    MONTO,
	    DESC_ARTICULO,
	    RCNid,
	    ORDEN,
	    ECODIGO,
	    BMUSUCODIGO)
	Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
		'SB',
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSalarioBase.monto#">,
		'Salario Bruto',
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
		11,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	)
</cfquery>--->


<cfquery datasource="sifinterfaces" name="rsSoin_BNV">
	Select * from INTP_SOIN_BNV
</cfquery>

<!--- Renta	5%, ASEVITAL, 1% CCSS, 8.17% CCSS, Salario Líquido--->
<cfloop from="0" to="4" index='i'>
	<cfif i EQ 0>	
		<cfset descrip = 'Salario liquido'>
		<cfset detalle = 'SL'>
		<cfset ord = 45>
	
	<cfelseif i EQ 1>	
		<cfset descrip = 'Salario liquido(Renta)'>
		<cfset detalle = 'SLR'>
		<cfset ord = 44>
		
	<cfelseif i EQ 2>	
		<cfset descrip = 'Salario liquido(CCSS %1)'>
		<cfset detalle = 'SLC1'>
		<cfset ord = 42>
		
	<cfelseif i EQ 3>	
		<cfset descrip = 'Salario liquido(CCSS %8.17)'>
		<cfset detalle = 'SLC8'>
		<cfset ord = 41>
		
	<cfelseif i EQ 4>	
		<cfset descrip = 'Salario liquido(Asevital)'>
		<cfset detalle = 'SLA'>
		<cfset ord = 43>
	</cfif>							
	
	<cfquery name="rsCods" dbtype="query">
		select * from rsSoin_BNV 
		where id_referencia=1 
		and subcodigo='#trim(detalle)#'
	</cfquery>
	
	<cfquery datasource="sifinterfaces">
		Insert into PRE_INTERFAZ_PRESUPUESTO(
			NUMERO_INTERFASE,
		    ID_REFERENCIA,
		    TIPO,
		    MONTO,
		    COD_EGRESO,
		    COD_ARTICULO,
		    DESC_ARTICULO,
		    RCNid,
		    ORDEN,
		    aplicaCCSS,
		    ECODIGO,
		    BMUSUCODIGO)
		Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
			1,
			'#detalle#',
			0 <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.monto#">--->,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_egreso#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_articulo#">,
		 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#descrip#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
			#ord#,
			1,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
	
</cfloop>

<cfloop query="rsCargas">
	<cfquery datasource="sifinterfaces">
		Insert into PRE_INTERFAZ_PRESUPUESTO(
			NUMERO_INTERFASE,
		    ID_REFERENCIA,
		    TIPO,
		    MONTO,
		    COD_EGRESO,
		    COD_ARTICULO,
		    DESC_ARTICULO,
		    RCNid,
		    ORDEN,
		    ECODIGO,
		    BMUSUCODIGO)
		Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.id#">,
			'C',
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.monto#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCargas.cod_egreso#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCargas.cod_articulo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCargas.desc_articulo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
			51,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
</cfloop>

<cfloop query="rsDeducciones">
	<cfquery datasource="sifinterfaces">
		Insert into PRE_INTERFAZ_PRESUPUESTO(
			NUMERO_INTERFASE,
		    ID_REFERENCIA,
		    TIPO,
		    MONTO,
		    COD_EGRESO,
		    COD_ARTICULO,
		    DESC_ARTICULO,
		    RCNid,
		    ORDEN,
		    ECODIGO,
		    BMUSUCODIGO)
		Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.id#">,
			'D',
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.monto#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDeducciones.cod_egreso#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDeducciones.cod_articulo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDeducciones.desc_articulo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
			61,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
</cfloop>

<cfloop query="rsIncidencias">
	
	<cfif rsIncidencias.nocarga EQ 0>
			
			<!--- Renta	5%, ASEVITAL, 1% CCSS, 8.17% CCSS, Salario Líquido--->
			<cfloop from="0" to="4" index='i'>
				<cfif i EQ 0>	
					<cfset descrip = '(Líquido)'>
					<cfset detalle = 'IL'>
					<cfset ord = 45>
				
				<cfelseif i EQ 1>	
					<cfset descrip = '(Renta)'>
					<cfset detalle = 'IR'>
					<cfset ord = 44>
					
				<cfelseif i EQ 2>	
					<cfset descrip = '(CCSS %1)'>
					<cfset detalle = 'IC1'>
					<cfset ord = 42>
					
				<cfelseif i EQ 3>	
					<cfset descrip = '(CCSS %8.17)'>
					<cfset detalle = 'IC8'>
					<cfset ord = 41>
					
				<cfelseif i EQ 4>	
					<cfset descrip = '(Asevital)'>
					<cfset detalle = 'IA'>
					<cfset ord = 43>
				
				</cfif>
				
				<cfquery name="rsCods" dbtype="query">
					select * from rsSoin_BNV 
					where id_referencia=#rsIncidencias.id# 
					and subcodigo='#trim(detalle)#'
				</cfquery>	
				
				<cfquery datasource="sifinterfaces">
					Insert into PRE_INTERFAZ_PRESUPUESTO(
						NUMERO_INTERFASE,
					    ID_REFERENCIA,
					    TIPO,
					    MONTO,
					    COD_EGRESO,
					    COD_ARTICULO,
					    DESC_ARTICULO,
					    RCNid,
					    ORDEN,
					    aplicaCCSS,
					    ECODIGO,
					    BMUSUCODIGO)
					Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.id#">,
						'#detalle#',
						0 <!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.monto#">--->,
						
						<cfif not len(trim(rsCods.cod_egreso))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.cod_egreso#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_egreso#">,
						</cfif>
						<cfif not len(trim(rsCods.cod_articulo))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.cod_articulo#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_articulo#">,
					 	</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.desc_articulo# #descrip#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
						#ord#,
						1,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
				</cfquery>
				
			</cfloop>
			
	<cfelse>
			<cfquery name="rsCods" dbtype="query">
				select * from rsSoin_BNV 
				where id_referencia=#rsIncidencias.id# 
				and subcodigo='I'
			</cfquery>	
				
			<cfquery datasource="sifinterfaces">
				Insert into PRE_INTERFAZ_PRESUPUESTO(
					NUMERO_INTERFASE,
				    ID_REFERENCIA,
				    TIPO,
				    MONTO,
				    COD_EGRESO,
				    COD_ARTICULO,
				    DESC_ARTICULO,
				    RCNid,
				    ORDEN,
				    ECODIGO,
				    BMUSUCODIGO)
				Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#num_interfase#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.id#">,
					'I',
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.monto#">,

					<cfif not len(trim(rsCods.cod_egreso))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.cod_egreso#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_egreso#">,
					</cfif>
					<cfif not len(trim(rsCods.cod_articulo))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.cod_articulo#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCods.cod_articulo#">,
				 	</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIncidencias.desc_articulo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">,
					40,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
			</cfquery>
	</cfif>
	
</cfloop>


</cftransaction>

<!--- actualiza los montos para el salario liquido ---->		
<cfquery  datasource="#session.DSN#" name="rsSL">
 	select * from #TMPCalculos#
 	where tipo = 'CS'
</cfquery>
<cfquery  datasource="sifinterfaces">
	Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSL.liquido#">
	where aplicaccss=1 and tipo = 'SL'
</cfquery>
<cfquery  datasource="sifinterfaces">
	Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSL.renta#">
	where aplicaccss=1 and tipo = 'SLR'
</cfquery>	
<cfquery  datasource="sifinterfaces">
	Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSL.CCSS1#">
	where aplicaccss=1 and tipo = 'SLC1'
</cfquery>	
<cfquery  datasource="sifinterfaces">
	Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSL.CCSS8#">
	where aplicaccss=1 and tipo = 'SLC8'
</cfquery>	
<cfquery  datasource="sifinterfaces">
	Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSL.Asevital#">
	where aplicaccss=1 and tipo = 'SLA'
</cfquery>	

<!--- actualiza los montos para las Incidencias ---->	
<cfquery  datasource="#session.DSN#" name="rsIncidencias">
 	select * from #TMPCalculos# where tipo = 'I'
</cfquery>
<cfloop query="rsIncidencias">	
<cfquery  datasource="sifinterfaces">
		Update pre_interfaz_presupuesto 
			set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.liquido#">
		where aplicaccss=1 and tipo = 'IL' 
		and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#">
	</cfquery>
	<cfquery  datasource="sifinterfaces">
		Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.renta#">
		where aplicaccss=1 and tipo = 'IR'
		and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#">
	</cfquery>	
	<cfquery  datasource="sifinterfaces">
		Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CCSS1#">
		where aplicaccss=1 and tipo = 'IC1'
		and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#">
	</cfquery>	
	<cfquery  datasource="sifinterfaces">
		Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CCSS8#">
		where aplicaccss=1 and tipo = 'IC8' 
		and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#">
	</cfquery>	
<cfquery  datasource="sifinterfaces">
		Update pre_interfaz_presupuesto set  monto= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.Asevital#">
		<!---,cod_egreso = (select cod_egreso from soin_bnv_subcuentas where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#"> and sub_tipo='IR' )--->
		where aplicaccss=1 and tipo = 'IA'
		and id_referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncidencias.CIid#">
	</cfquery>	
</cfloop>	
	


</cfoutput>