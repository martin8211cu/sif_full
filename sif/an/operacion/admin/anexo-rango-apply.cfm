<cfinclude template="anexo-validar-permiso.cfm">
<!--- tomado de SQLAnexoCel.cfm --->
<cfparam name="form.ANubicaGOid" default="-1">
<cfparam name="form.ANubicaGEid" default="-1">
<cfparam name="form.ANubicaOcodigo" default="-1">
<cfparam name="form.ANubicaEcodigo" default="-1">

<cfquery name="rsAnexo" datasource="#session.DSN#">
	select AnexoSaldoConvertido
	from Anexo
	where Ecodigo = <cfqueryparam 	cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
</cfquery>
<cfif not isdefined("form.Nuevo")>

	<!--- 
		Flechas de Navegación a la siguiente celda de una misma hoja:
			Fila Anterior, Fila Siguiente, Columna Anterior, Columna Siguiente
	--->
	<cfset LvarBtnFlechaCelda = false>
	<cfif isdefined("form.btnFilaA")>
		<cfset LvarBtnFlechaCelda = true>
		<cfset LvarBtnFlechaWhere = "s.AnexoColumna = a.AnexoColumna and s.AnexoFila < a.AnexoFila OR s.AnexoColumna < a.AnexoColumna">
		<cfset LvarBtnFlechaOrder = "(s.AnexoColumna * 100000 + s.AnexoFila) desc">
	<cfelseif isdefined("form.btnFilaS")>
		<cfset LvarBtnFlechaCelda = true>
		<cfset LvarBtnFlechaWhere = "s.AnexoColumna = a.AnexoColumna and s.AnexoFila > a.AnexoFila OR s.AnexoColumna > a.AnexoColumna">
		<cfset LvarBtnFlechaOrder = "(s.AnexoColumna * 100000 + s.AnexoFila) asc">
	<cfelseif isdefined("form.btnColA")>
		<cfset LvarBtnFlechaCelda = true>
		<cfset LvarBtnFlechaWhere = "s.AnexoFila = a.AnexoFila and s.AnexoColumna < a.AnexoColumna OR s.AnexoFila < a.AnexoFila">
		<cfset LvarBtnFlechaOrder = "(s.AnexoFila * 100000 + s.AnexoColumna) desc">
	<cfelseif isdefined("form.btnColS")>
		<cfset LvarBtnFlechaCelda = true>
		<cfset LvarBtnFlechaWhere = "s.AnexoFila = a.AnexoFila and s.AnexoColumna > a.AnexoColumna OR s.AnexoFila > a.AnexoFila">
		<cfset LvarBtnFlechaOrder = "(s.AnexoFila * 100000 + s.AnexoColumna) asc">
	</cfif>
		
	<cfif LvarBtnFlechaCelda>
		<cfquery name="rsSQL" datasource="#Session.DSN#" maxrows="1">
			select s.AnexoCelId, s.AnexoFila, s.AnexoColumna
			  from AnexoCel a
			  	inner join AnexoCel s
				   on s.AnexoId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
				  and s.AnexoHoja = a.AnexoHoja
				  and s.AnexoFila > 0 AND s.AnexoColumna > 0
				  and (#LvarBtnFlechaWhere#)
			 where a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
			   and a.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			 order by #LvarBtnFlechaOrder#
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfset Form.AnexoCelId = rsSQL.AnexoCelId>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Session.DSN#" maxrows="1">
				select s.AnexoCelId, s.AnexoFila, s.AnexoColumna
				  from AnexoCel a
					inner join AnexoCel s
					   on s.AnexoId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
					  and s.AnexoHoja = a.AnexoHoja
					  and s.AnexoFila > 0 AND s.AnexoColumna > 0
				 where a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
				   and a.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
				 order by 
				 <cfif isdefined("form.btnFilaA")>s.AnexoFila desc<cfelse>s.AnexoColumna asc</cfif>
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset Form.AnexoCelId = rsSQL.AnexoCelId>
			</cfif>
		</cfif>

		<cflocation url="anexo.cfm?tab=2&cta=1&AnexoId=#Form.AnexoId#&AnexoCelId=#Form.AnexoCelId#">

	<cfelseif isdefined("Form.ALTA") or IsDefined('Form.CAMBIO') And Len(Form.AnexoCelId) EQ 0>
		
		<cfquery name="AnexoCel_ABC" datasource="#Session.DSN#">
			insert into AnexoCel (AnexoId, AnexoHoja, Ecodigo, AnexoRan, AnexoCon, 
								AnexoRel, AnexoMes, AnexoPer, 
								Ecodigocel,	Ocodigo, GEid, GOid,
								AnexoNeg, Ecodigocel, AVid, 
								CPtipoSaldo, ANFid, ANHid, ANHCid,
								Mcodigo, ACmlocal)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">,
				<cfif isdefined("Form.AnexoHoja")>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoHoja#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_char" value="Sheet1">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoRan#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoCon#">,
				<cfif isdefined("Form.AnexoRel")>
					1,
					#Form.AnexoMes#,
					0,
				<cfelse>
					0,
					#Form.Meses#,
					#Form.AnexoPer#,
				</cfif>

				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaEcodigo#" 	null="#Form.ANubicaTipo eq "GE" OR Form.ANubicaTipo eq ""#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaOcodigo#" 	null="#Form.ANubicaTipo neq "O"#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGEid#" 	null="#Form.ANubicaTipo neq "GE"#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGOid#" 	null="#Form.ANubicaTipo neq "GO"#">

				#iif(isdefined("Form.AnexoNeg"),1,0)#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigocel#" null="#Form.Ecodigocel eq -1#">

				<cfif form.AnexoCon EQ "3">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AVid#" null="#Len(Form.AVid) EQ 0#">
				<cfelse>
					,null
				</cfif>
				<cfif form.AnexoCon GTE "50" and form.AnexoCon LTE "59">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPtipoSaldo#">,
				<cfelse>
					,null
				</cfif>
				<cfif form.AnexoCon GTE "60" and form.AnexoCon LTE "69">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANFid#">,
				<cfelse>
					,null
				</cfif>
				<cfif form.ANHid EQ "">
					, null , null
				<cfelse>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANHid#">,
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANHCid#">,
				</cfif>

				<cfparam name="form.Mcodigo" default="-1">
				<cfparam name="form.ACmLocal" default="0">
				<cfif rsAnexo.AnexoSaldoConvertido NEQ 2 or form.Mcodigo EQ -1>
					,null
					,0
				<cfelse>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_bit" value="#Form.ACmLocal#">
				</cfif>
			)
		
			select @@identity as AnexoCelId	
		</cfquery>
		
		<cfset form.AnexoCelId = AnexoCel_ABC.AnexoCelId >
		<cfset modo = "ALTA">
		
	<cfelseif isdefined("Form.CAMBIO") And Len(Form.AnexoCelId) NEQ 0>

		<!---
		Sólo se puede modificar el concepto entre alguno de los siguientes conceptos cuando
		hay registros en la tabla AnexoCelConcepto: Débitos Mes, Créditos Mes, Movimiento Mes,
		Débitos Período, Créditos Período, Movimiento Período.
		--->
		<cfquery name="rsVerificaConcepto" datasource="#Session.DSN#">
			select count(1) as cantidad
			from AnexoCelConcepto
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">			  
		</cfquery>
		<cfset cTotal = rsVerificaConcepto.cantidad>
		<cfset strConceptos = "22,23,24,32,33,34">
		<cfif not #ListFind(strConceptos,Form.AnexoCon,",")# and cTotal neq 0>
			<script language="JavaScript">
				var  mensaje = new String("No es posible modificar la celda.");
				alert(mensaje)
				document.location = "anexo.cfm?tab=2&cta=1&AnexoId=<cfoutput>#Form.AnexoId#</cfoutput>&AnexoCelId=<cfoutput>#Form.AnexoCelId#</cfoutput>";
			</script>			
			<cfabort>	
		<cfelse>
			<!--- 
			Si el concepto que se desea poner es menor que 20 se verifica si hay cuentas
			en cuyo caso se le indica al usuario que no es posible hacer el cambio hasta que limpie
			las cuentas
			--->
			<cfparam name="form.ANHid" default="">
			<cfif Form.AnexoCon LT 20 and len(Form.AnexoCon) OR form.ANHid NEQ "">
		
				<cfquery name="verificacionctas" datasource="#Session.DSN#">
					Select count(1) as cantidad
					  from AnexoCelD a
					 where a.AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
				</cfquery>
					
				<cfset Tcantidad = verificacionctas.cantidad>
			<cfelse>
				<cfset Tcantidad = 0>	
			</cfif>
				
			<cfif Tcantidad gt 0>
				<cfoutput>
				<script language="JavaScript">
					var  mensaje = new String("No es posible modificar la celda porque contiene máscaras de Cuentas Financieras definidas:\n borre primero todas las máscaras.");				
					alert(mensaje);
					document.location = "anexo.cfm?tab=2&cta=1&AnexoId=<cfoutput>#Form.AnexoId#</cfoutput>&AnexoCelId=<cfoutput>#Form.AnexoCelId#</cfoutput>";
				</script>
				</cfoutput>		
				<cfabort>					
			<cfelse>
				
				<!--- Antes de actualizar se verifica contra el excel. Si se encuentra la celda
				se actualiza normalmente y queda como parte de la hoja o ya definida, de acuerdo
				a si tiene concepto o no. En caso de no aparecer en el excel, se conserva el estado
				normal de la celda pero la fila y la columna pasan a ser cero, por lo que quedaría
				en un estado de que solo existe en BD

				<cfquery name="exc_xml" datasource="#Session.DSN#">
				Select AnexoDef
				from Anexoim
				where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
				</cfquery>

				<cfif exc_xml.recordcount gt 0>

					<cfset excel_xml = exc_xml.AnexoDef>
					
					<!--- Parsea el XML y lo deja en un recordset --->
					<cfinvoke component="sif.an.operacion.admin.anexo-UpParseoXML" 
					method="ParsearXML"
					returnvariable="resultado_parseo"
					excel_xml = "#excel_xml#"/>
	
					<cfquery name="encontrada" dbtype="query">
					Select name,row,col
					from resultado_parseo
					where Upper(name) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(Form.AnexoRan))#">
					</cfquery>
								
					<cfset existexl = encontrada.recordcount>
				<cfelse>
					<cfset existexl = 0> 
				</cfif>
				
				<cfif existexl gt 0>
				
					<cfset Nfila = encontrada.row>
					<cfset Ncolu = encontrada.col>
					 --->
					
					<!--- Si existe en el excel --->				
					<cfquery datasource="#Session.DSN#">
						update AnexoCel set 
							AnexoRan = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoRan#">,
							AnexoCon = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AnexoCon#">,
							<cfif isdefined("Form.AnexoRel")>
								AnexoRel = 1,
								AnexoMes = #Form.AnexoMes#,
								AnexoPer = 0,
							<cfelse>
								AnexoRel = 0,
								AnexoMes = #Form.Meses#,
								AnexoPer = #Form.AnexoPer#,
							</cfif>
							AnexoNeg = #iif(isdefined("Form.AnexoNeg"),1,0)#,
							
							<cfif form.AnexoCon EQ "3">
								AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AVid#" null="#Len(Form.AVid) EQ 0#">,
							<cfelse>
								AVid = null,
							</cfif>
							<cfif form.AnexoCon GTE "50" and form.AnexoCon LTE "59">
								CPtipoSaldo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPtipoSaldo#">,
							<cfelse>
								CPtipoSaldo = null,
							</cfif>
							<cfif form.AnexoCon GTE "60" and form.AnexoCon LTE "69">
								ANFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANFid#">,
							<cfelse>
								ANFid = null,
							</cfif>
							<cfif form.ANHid EQ "">
								ANHid=null , ANHCid=null,
							<cfelse>
								ANHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANHid#">,
								ANHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANHCid#">,
							</cfif>

							Ecodigocel 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaEcodigo#" 	null="#Form.ANubicaTipo eq "GE" OR Form.ANubicaTipo eq ""#">,
							Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANubicaOcodigo#" 	null="#Form.ANubicaTipo neq "O"#">,
							GEid	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGEid#" 		null="#Form.ANubicaTipo neq "GE"#">,
							GOid	 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ANubicaGOid#" 		null="#Form.ANubicaTipo neq "GO"#">

							<cfparam name="form.Mcodigo" default="-1">
							<cfparam name="form.ACmLocal" default="0">
							<cfif rsAnexo.AnexoSaldoConvertido NEQ 2 or form.Mcodigo EQ -1 or NOT (form.AnexoCon GTE "20" and form.AnexoCon LTE "39")>
								, Mcodigo = null
								, ACmLocal = 0
							<cfelse>
								, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
								, ACmLocal = <cfqueryparam cfsqltype="cf_sql_bit" value="#Form.ACmLocal#">
							</cfif>
						where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
					</cfquery>
				<!---
				<cfelse>
					 No existe en el excel 
					<cfquery datasource="#Session.DSN#">
						update AnexoCel set 
							AnexoRan = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.AnexoRan#">,
							AnexoFila = 0,
							AnexoColumna = 0
						where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
					</cfquery>
										
				</cfif>--->
				
			</cfif>
		</cfif>								
		<cfset modo = "CAMBIO">
		
	<cfelseif isdefined("Form.BAJA")>

		<!--- ======================================================== --->
		<!--- ======================================================== --->
		<!--- Solicitado por mauricio arias: borrar estas tablas cuando
			  anexoFila y AnexoColumna  sean igual a 0 en AnexoCel 
		--->
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select count(1) as total
			from AnexoCel
			where Ecodigo = <cfqueryparam 	cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			  and AnexoFila = 0
			  and AnexoColumna = 0
		</cfquery>
		
		<cfif rsDatos.total gt 0>
			<cfquery datasource="#Session.DSN#">
				Delete from AnexoCalculoRango where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			</cfquery>
	
			<cfquery datasource="#Session.DSN#">
				Delete from AnexoCelConcepto where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			</cfquery>
	
			<cfquery datasource="#Session.DSN#">
				Delete from AnexoCelD where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			</cfquery>
	
			<cfquery datasource="#Session.DSN#">
				Delete from AnexoCel where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
			</cfquery>
		</cfif>
		<!--- ======================================================== --->
		<!--- ======================================================== --->

		<!--- esta parte es del cfm origal, tal y como estaba antes de agregar lo anterior--->
		<cfquery datasource="#Session.DSN#">
			delete from AnexoCelConcepto
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from AnexoCelD
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		</cfquery>

		<cfquery datasource="#Session.DSN#">
			delete from AnexoCel
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		</cfquery>

		<cfset modo = "ALTA">

	<cfelseif isdefined("Form.QUITAR")>
		<cfquery datasource="#Session.DSN#">
			delete from AnexoCelConcepto
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoCelId#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from AnexoCelD
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
			update AnexoCel
			   set AnexoCon = null
			where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">
		</cfquery>
		<cfset modo = "ALTA">
	</cfif>
</cfif>

<cfset fltr = "&nav=1">
<cfif isdefined("form.F_Hoja") and len(trim(form.F_Hoja)) gt 0>
	<cfset fltr = fltr & "&F_Hoja=#form.F_Hoja#">
</cfif>
<cfif isdefined("form.F_columna") and form.F_columna gt 0>
	<cfset fltr = fltr & "&F_columna=#form.F_columna#">
</cfif>
<cfif isdefined("form.F_fila") and form.F_fila gt 0>
	<cfset fltr = fltr & "&F_fila=#form.F_fila#">
</cfif>
<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>
	<cfset fltr = fltr & "&F_Rango=#form.F_Rango#">
</cfif>				
<cfif isdefined("form.F_Estado") and form.F_Estado gt 0>
	<cfset fltr = fltr & "&F_Estado=#form.F_Estado#">
</cfif>
<cfif isdefined("form.F_Cuentas") and form.F_Cuentas gt -1>
	<cfset fltr = fltr & "&F_Cuentas=#form.F_Cuentas#">
</cfif>		

<cfif isdefined("form.BAJA")>
	<cfif isdefined("form.Ppagina")>
		<cfset pagina = "&pagina=#form.Ppagina#">
	</cfif>
	<cflocation url="anexo.cfm?tab=2&AnexoId=#Form.AnexoId##pagina##fltr#">
<cfelse>

	<cfif isdefined("form.ALTA")>
		<cfset form.AnexoCelId = AnexoCel_ABC.AnexoCelId >
	</cfif>
	<cfset pagina = "">
	<cfif isdefined("form.Ppagina")>
		<cfset pagina = "&Ppagina=#form.Ppagina#">
	</cfif>
	<cflocation url="anexo.cfm?tab=2&cta=1&AnexoId=#Form.AnexoId#&AnexoCelId=#Form.AnexoCelId##pagina##fltr#">
</cfif>

