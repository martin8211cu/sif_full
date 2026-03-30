<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>


<cfif listLen(GvarXML_IE) NEQ 4>
<cfthrow message="Son requeridos 4 Datos de entrada: Cconcepto, fecha_ini, fecha_fin, Modo">
</cfif>
<cfset LvarCconcepto = listGetAt(GvarXML_IE,1)>
<cfset LvarFechaIni = listGetAt(GvarXML_IE,2)>
<cfset LvarFechaFin  = listGetAt(GvarXML_IE,3)>
<cfset LvarEmodo 	 = listGetAt(GvarXML_IE,4)>

<cfif LvarEmodo EQ -1 or LvarEmodo eq ' '>
	<cfset LvarEmodo = 'D'>
</cfif>


<cfquery name="rsSQL" datasource="#session.dsn#">
	Select ECIid 
	  from EContablesImportacion   
	 where Ecodigo		=#session.Ecodigo#
	  	and Cconcepto 	=#LvarCconcepto#
	  	and Efecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> and  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
</cfquery>

<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="No existen  Asientos Importados para el Concepto: #LvarCconcepto# entre las fechas :#LvarFechaIni# y  #LvarFechaFin#">
</cfif>


<cfif #LvarEmodo# eq 'E'>
<!---para cuando es Creditos--->
<cfquery name="rsSQL" datasource="#session.dsn#">
Select distinct
		e.Eperiodo,
		e.Emes,
		e.Cconcepto,
		e.Edescripcion,
		e.Efecha,
        sum (Doriginal)	as  Doriginal_C,
		sum (Dlocal)	as Dlocal_C

	from EContablesImportacion  e
	  inner join  DContablesImportacion d
	  on e.ECIid=d.ECIid      
	and e.Ecodigo=d.Ecodigo
	 where e.Ecodigo	= #session.Ecodigo#
	 	and e.Cconcepto=# LvarCconcepto#
	  	and e.Efecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> and  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
        and Dmovimiento='C'
group by e.Eperiodo,
		e.Emes,
		e.Cconcepto,
		e.Edescripcion,
		e.Efecha
</cfquery>
<!---para cuando es Debitos--->
<cfquery name="rsSQLD" datasource="#session.dsn#">
Select  sum (Doriginal)	as  Doriginal_D,
		sum (Dlocal)	as Dlocal_D

	from EContablesImportacion  e
	  inner join  DContablesImportacion d
	  on e.ECIid=d.ECIid      
	and e.Ecodigo=d.Ecodigo
	 where e.Ecodigo	= #session.Ecodigo#
	 	and e.Cconcepto=# LvarCconcepto#
	  	and e.Efecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> and  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
        and Dmovimiento='D'
</cfquery>

</cfif>

<cfif #LvarEmodo# eq 'D'>
<cfquery name="rsSQL" datasource="#session.dsn#">
	Select 
	  	e.Eperiodo,
		e.Emes,
		e.Cconcepto,
		e.Efecha,
		d.DCIlinea,
		d.Ddescripcion,
		d.CFformato,
		c.Cdescripcion,
		d.Ocodigo,
		o.Odescripcion,
		m.Mnombre,
		m.Msimbolo,
		d.Dmovimiento,
		d.Doriginal,
		d.Dlocal
	from EContablesImportacion  e
	  inner join  DContablesImportacion d
	  	on e.ECIid=d.ECIid     
	  inner join Monedas m 
	  	on d.Mcodigo=m.Mcodigo
	  inner join Oficinas o
		  on o.Ocodigo=d.Ocodigo
		  and o.Ecodigo=d.Ecodigo
	  inner join CContables c
	  	  on c.Cformato=d.CFformato 	
		  and c.Ecodigo=d.Ecodigo
	 where e.Ecodigo	= #session.Ecodigo#
	 	and e.Cconcepto=# LvarCconcepto# 
	  	and e.Efecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> and  <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
</cfquery>
</cfif>

<cfset LvarTabla = "<recordset>">

	<cfif #LvarEmodo# eq 'E'> 
		<cfloop query="rsSQL">
			<cfset LvarTabla &= " 
			<row>
				<Empresa>			#session.Ecodigo#		</Empresa>
				<Periodo>			#rsSQL.Eperiodo#		</Periodo>
				<Mes>				#rsSQL.Emes#			</Mes>
				<Concepto>			#rsSQL.Cconcepto#		</Concepto>
				<Descripcion>		#rsSQL.Edescripcion#	</Descripcion>
				<Fecha>				#rsSQL.Efecha#			</Fecha>
				<Original Creditos>	#rsSQL.Doriginal_C#		</Original>
				<Local Creditos>	#rsSQL.Dlocal_C#		</Local Creditos>
				<Original Debitos>	#rsSQLD.Doriginal_D#	</Original Debitos>
				<Local Debitos>		#rsSQLD.Dlocal_D#		</Local Debitos>
			</row>">
		</cfloop>
	</cfif>
	
	<cfif #LvarEmodo# eq 'D'> 
		<cfloop query="rsSQL">
			<cfset LvarTabla &= " 
			<row>
				<Empresa>				#session.Ecodigo#		</Empresa>
				<Periodo>				#rsSQL.Eperiodo#		</Periodo>
				<Mes>					#rsSQL.Emes#			</Mes>
				<Concepto>				#rsSQL.Cconcepto#		</Concepto>
				<Fecha>					#rsSQL.Efecha#			</Fecha>
				<Linea>					#rsSQL.DCIlinea#		</Linea>
				<Descripcion>			#rsSQL.Ddescripcion#	</Descripcion>
				<Formato>				#rsSQL.CFformato#		</Formato>  
				<Descripcion Formato>	#rsSQL.Cdescripcion#	</Descripcion Formato>  
				<Codigo Oficina>		#rsSQL.Ocodigo#			</Codigo Oficina>
				<Descripcion Oficina>	#rsSQL.Odescripcion#	</Descripcion Oficina>
				<Nombre Moneda>			#rsSQL.Mnombre#			</Nombre Moneda>
				<Simbolo Moneda>		#rsSQL.Msimbolo#		</Simbolo Moneda>
				<Movimiento>			#rsSQL.Dmovimiento#		</Movimiento>
				<Monto Original>		#rsSQL.Doriginal#		</Monto Original>  
				<Monto Local>			#rsSQL.Dlocal#			</Monto Local>
			</row>">
		</cfloop>
	</cfif>
	
<cfset LvarTabla &= "<recordset>">

<cfset GvarXML_OE = LvarTabla>

