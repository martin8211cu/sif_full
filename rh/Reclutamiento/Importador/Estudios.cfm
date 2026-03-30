<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- Check1. verifica el tipo de identificación --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El c&oacute;digo de identificaci&oacute;n&nbsp;(<b>',a.NTIcodigo, '</b>)&nbsp;no existe en el cat&aacute;logo'" >, 1	
	from #table_name# a
	where not exists (	select 1 from NTipoIdentificacion b
					where ltrim(rtrim(b.NTIcodigo ))		  = ltrim(rtrim(a.NTIcodigo))
					and b.Ecodigo = #Session.Ecodigo#
					)	
</cfquery>

<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select distinct
	<cf_dbfunction name="concat" args="'El Oferente no existe el catálogo. Tipo Iden.&nbsp;(<b>',a.NTIcodigo,'</b>)&nbsp; Identificaci&oacute;n &nbsp;(<b>',a.RHOidentificacion,'</b>)'" >, 2
	from #table_name# a
	where not exists (	select 1 from DatosOferentes b
					where  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ltrim(rtrim(b.NTIcodigo))	      = ltrim(rtrim(a.NTIcodigo)) 
					and ltrim(rtrim(b.RHOidentificacion)) = ltrim(rtrim(a.RHOidentificacion))
					)	
</cfquery>
<!--- Check3. verfica la situacion Actualmente  --->
<cf_dbfunction name="to_char" args="a.RHEsinterminar" returnvariable="RHEsinterminar">
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  
	select 
	<cf_dbfunction name="concat" args="'El campo estudios sin terminar no es v&aacute;lido&nbsp;:(<b>'|#RHEsinterminar#|'</b>) para el oferente &nbsp;(<b>'|a.RHOidentificacion|'</b>)'"  delimiters ="|">,3	
	from #table_name# a
	where a.RHEsinterminar not in (0,1)
</cfquery>


<cfquery name="ERR" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum,Mensaje
</cfquery>
<cfif (ERR.recordcount) EQ 0>

<!--- Primero inserta instituciones ,grados y titulos que no existen en los catalogos --->
		<cfquery name="rstitulo" datasource="#Session.DSN#">			
			insert INTO RHOTitulo (CEcodigo, RHOTDescripcion,BMfechaalta, BMUsucodigo) 
			select 
				 #session.CEcodigo# , 
				 rtrim(ltrim(a.RHEtitulo)), 
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
				 #session.Usucodigo#
			from #table_name# a	 
			where not exists  
			(	select 1 from RHOTitulo  b
					where  CEcodigo = #session.CEcodigo#
					and RHOTDescripcion =   rtrim(ltrim(a.RHEtitulo))
					)	
		</cfquery>
		
		<cfquery name="rsInstituciones" datasource="#Session.DSN#">			
			insert INTO RHInstitucionesA (Ecodigo,CEcodigo,RHIAcodigo,RHIAnombre,BMfecha, BMUsucodigo) 
			select 
				#session.Ecodigo#, 
				#session.CEcodigo# , 
				'INS-IMP',
				 rtrim(ltrim(a.Institucion)) , 
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
				 #session.Usucodigo#
			from #table_name# a	 
			where not exists  
			(	select 1 from RHInstitucionesA  b
					where Ecodigo  =  #session.Ecodigo#
					and  CEcodigo =   #session.CEcodigo#
					and RHIAnombre =  rtrim(ltrim(a.Institucion)) 
					)						  
		</cfquery>	
			
		<cfquery name="rsGrados" datasource="#Session.DSN#">			
			insert INTO GradoAcademico (Ecodigo,GAnombre,GAorden, BMUsucodigo) 
			select  
				#session.Ecodigo#, 
				rtrim(ltrim(a.GradoAcademico)), 
				 1, 
				 #session.Usucodigo# 
			from #table_name# a	 
			where not exists  
			(	select 1 from GradoAcademico  b
					where Ecodigo  =  #session.Ecodigo#
					and GAnombre =  rtrim(ltrim(a.GradoAcademico)) 
					)		 
		</cfquery>


		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHEducacionEmpleado(RHOid, Ecodigo,RHEtitulo,RHEfechaini, RHEfechafin, RHEsinterminar, BMUsucodigo, BMfecha,RHECapNoFormal,RHOTid,RHIAid,GAcodigo,RHEestado)
			select 
				a.RHOid,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				b.RHEtitulo,
				b.RHEfechaini,
				b.RHEfechafin,
				b.RHEsinterminar,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> ,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				RHECapNoFormal,
				c.RHOTid,
				d.RHIAid,
				e.GAcodigo,
				1
			from DatosOferentes a ,#table_name# b,
			RHOTitulo c, RHInstitucionesA d,GradoAcademico e
			where   a.Ecodigo 						= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ltrim(rtrim(b.NTIcodigo))			= ltrim(rtrim(a.NTIcodigo ))
			and ltrim(rtrim(b.RHOidentificacion)) 	= ltrim(rtrim(a.RHOidentificacion))
			and c.RHOTDescripcion 					= rtrim(ltrim(b.RHEtitulo))
			and d.RHIAnombre 						= rtrim(ltrim(b.Institucion)) 
			and e.GAnombre 							= rtrim(ltrim(b.GradoAcademico))
			and c.CEcodigo 							= #session.CEcodigo# 
			and d.Ecodigo 							=  a.Ecodigo
			and c.CEcodigo 							=  d.CEcodigo 
			and e.Ecodigo 							=  a.Ecodigo
		</cfquery>
</cfif>
