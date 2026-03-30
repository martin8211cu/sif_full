<cfquery name="rsAid" datasource="#session.DSN#">
		select min(Aid) as Alm_Aid
			from Almacen
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
		<cfset Aid = rsAid.Alm_Aid>
		
	<cfquery name="existencia" datasource="#session.DSN#">
		select count(1) as check1
		from #table_name# a
		where (select count(1) 
			from Articulos b
				inner join Existencias e
				on b.Aid = e.Aid
			  where rtrim(a.sapno) = rtrim(b.Acodigo)
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and e.Alm_Aid  =#Aid#) < 1
	</cfquery>
	

		<cfif existencia.RecordCount lte 1>
				<cfquery name="rsPeriodo" datasource="#session.DSN#">
					select Pvalor as value
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo = 50
				</cfquery>
				<cfset periodo = rsPeriodo.value>

				<cfquery name="rsMes" datasource="#session.DSN#">
					select Pvalor as value
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo = 60
				</cfquery>
				<cfset mes = rsMes.value>
			
	<cf_dbfunction name="length" args="#rsMes.mes#" returnvariable ="mes01"> 
	<cf_dbfunction name="sRepeat" args="'0',2 - #preservesinglequotes(mes01)#" returnvariable ="Lvarm01"> 
	<cf_dbfunction name="concat" args="#preservesinglequotes(Lvarm01)#+ ltrim(#Mes.mes#)" returnvariable="Lvarm02" delimiters = "+">
		
<!--- Crea la FechaAux a partir del periodo / mes y le pone el ultimo dia del mes --->
	<cfset rsFechaAux = CreateDate(Arguments.periodo, rsMes.mes, 01)>
	<cfset rsFechaAux = DateAdd("m",1,rsFechaAux)>
	<cfset rsFechaAux = DateAdd("d",-1,rsFechaAux)>
	<cfset rsFechaAux = DateAdd("h",23,rsFechaAux)>
	<cfset rsFechaAux = DateAdd("n",59,rsFechaAux)>
	<cfset rsFechaAux = DateAdd("s",59,rsFechaAux)>	
	
	
  <cf_dbfunction name="concat" args="'PR-'+ #rsPeriodo.periodo#+'-'+#rsMes.mes#"  returnvariable="doc" delimiters = "+">
	<cfquery  name="insertEtrans" datasource="#Session.DSN#">
		insert into ETransformacion
		(
			Ecodigo,
			Usucodigo,
			Ulocalizacion,
			ETfecha,
			ETdocumento,
			ETcostoProd
		)
	  values
	  (
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
		  #session.Usucodigo#, 
		  #Session.Ulocalizacion#, 
		  #rsFechaAux#, 
		  #preservesinglequotes(doc)#
		  0.00
	   )
	</cfquery>
	
	
	<cfquery  name="selectDtrans"datasource="#Session.DSN#">
		select 
		  a.Aid, 
		  t.sapno as Acodigo, 
		  a.Ucodigo, 
		  t.Product as DTobservacion, 
		  t.Opening as DTinvinicial, 
		  t.Receipts as DTrecepcion, 
		  t.Production as DTprodcons, 
		  t.Shipments as DTembarques, 
		  t.Own as DTconsumopropio, 
		  t.LossGain as DTperdidaganancia, 
		  t.Ending as DTinvfinal, 
		  1.00 as DTfactor, 
		  1.00 as DTcostoU, 
		  1.00  as DTcostoT
			from #table_name# t
			 inner join Articulos a
			 on rtrim(a.Acodigo) = rtrim(t.sapno)
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		
	</cfquery>
	<cfquery  name="insertDtrans"datasource="#Session.DSN#">
		insert into DTransformacion
		(
		Aid, 
		Alm_Aid, 
		Acodigo, 
		Ucodigo, 
		DTobservacion, 
		DTinvinicial, 
		DTrecepcion, 
		DTprodcons, 
		DTembarques, 
		DTconsumopropio, 
		DTperdidaganancia, 
		DTinvfinal, 
		DTfactor, 
		DTfecha,
		DTcostoU, 
		DTcostoT
		)
		VALUES(
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectDtrans.Aid#"               voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Aid#"           				voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="15"  value="#selectDtrans.Acodigo#"           voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectDtrans.Ucodigo#"           voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectDtrans.DTobservacion#"     voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTinvinicial#"      voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTrecepcion#"       voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTprodcons#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTembarques#"       voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTconsumopropio#"   voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTperdidaganancia#" voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTinvfinal#"        voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectDtrans.DTfactor#"          voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
       <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectDtrans.DTcostoU#"          voidNull>,
       <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectDtrans.DTcostoT#"          voidNull>
)
		  
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
		<cf_dbidentity2 name="insertDtrans" datasource="#Arguments.Conexion#" verificar_transaccion="false">

<cfquery datasource="#Session.DSN#">
 update DTransformacion 
	set Aid =(select Aid 
		  from Articulos 
		   where Acodigo = DTransformacion.Acodigo 
		 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> )
	where (select count(1)
		from Articulos 
		where DTransformacion.Acodigo = Acodigo
		)> 0
   and 
		(select count(1) 
			from ETransformacion 
				where ETid = DTransformacion.ETid
				and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">) > 0
  and Aid is null 
</cfquery>
<cfelse> 
<cfquery name="ERR" datasource="#session.DSN#">
	 select 
	 <cf_dbfunction name="concat" args="'Artículo no Existe o no tiene Existencias:'+ a.sapno" delimiters="+"> as Motivo
	  from #table_name# a
		where (select count(1) from Articulos b
			inner join Existencias e
			on b.Aid = e.Aid
			 where rtrim(a.sapno) = rtrim(b.Acodigo)
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and e.Alm_Aid  = #Aid#"
			) < 1
</cfquery>							
</cfif>



