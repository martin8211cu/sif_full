<cfif isdefined("Form.ETidtracking")>
	<cfset idtracking = Form.ETidtracking>
</cfif>

<cfif isdefined("Form.ETidtracking") and Len(Trim(Form.ETidtracking))>
	<!--- Averiguar empresa y cache a utilizar --->
	<cfquery name="rsCache" datasource="sifpublica">
		select CEcodigo, EcodigoASP, Ecodigo, cncache
		from ETracking
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
	</cfquery>
</cfif>

<!--- Creación e Inserción del Encabezado del Tracking --->
<cfif isdefined("form.Alta")>
	<cftransaction>
		<cfinvoke 
		 component="sif.Componentes.CM_GeneraTracking"
		 method="generarNumTracking"
		 returnvariable="idtracking">
			<cfinvokeargument name="CEcodigo" value="#Session.CEcodigo#"/>
			<cfinvokeargument name="EcodigoASP" value="#Session.EcodigoSDC#"/>
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
			<cfinvokeargument name="cncache" value="#Session.DSN#"/>
			<cfinvokeargument name="EOidorden" value="#Form.EOidorden#"/>
			<cfinvokeargument name="ETfechasalida" value="#Form.ETfechasalida#"/>
			<cfinvokeargument name="ETfechaestimada" value="#Form.ETfechaestimada#"/>
			<cfinvokeargument name="ETfechaentrega" value="#Form.ETfechaentrega#"/>
			<cfinvokeargument name="ETnumreferencia" value="#Form.ETnumreferencia#"/>
			<cfinvokeargument name="CRid" value="#Form.CRid#"/>
			<cfinvokeargument name="ETnumembarque" value="#Form.ETnumembarque#"/>
			<cfinvokeargument name="ETrecibidopor" value="#Form.ETrecibidopor#"/>
			<cfinvokeargument name="ETmediotransporte" value="#Form.ETmediotransporte#"/>
		</cfinvoke>
	</cftransaction>
	<cfif idtracking NEQ 0>
		<cfset Form.ETidtracking = idtracking>
	</cfif>

<!--- Modificación del Encabezado del Tracking --->
<cfelseif isdefined("form.Cambio")>
	<cftransaction>
		<cfinvoke 
		 component="sif.Componentes.CM_GeneraTracking"
		 method="updNumTracking">
			<cfinvokeargument name="Ecodigo" value="#rsCache.Ecodigo#"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
			<cfinvokeargument name="ETidtracking" value="#Form.ETidtracking#"/>
			<cfinvokeargument name="ETestado" value="#Form.ETestado#"/>
			<cfinvokeargument name="ETfechasalida" value="#Form.ETfechasalida#"/>
			<cfinvokeargument name="ETfechaestimada" value="#Form.ETfechaestimada#"/>
			<cfinvokeargument name="ETnumreferencia" value="#Form.ETnumreferencia#"/>
			<cfinvokeargument name="CRid" value="#Form.CRid#"/>
			<cfinvokeargument name="ETnumembarque" value="#Form.ETnumembarque#"/>
			<cfinvokeargument name="ETmediotransporte" value="#Form.ETmediotransporte#"/>
			<cfif isdefined("Form.ETestado") and Form.ETestado EQ 'E'>
				<cfinvokeargument name="ETfechaentrega" value="#Form.ETfechaentrega#"/>
				<cfinvokeargument name="ETrecibidopor" value="#Form.ETrecibidopor#"/>
			</cfif>
		</cfinvoke>
	</cftransaction>

<!--- Mover los itemes seleccionados a un tracking existente --->
<cfelseif isdefined("Form.btnConsolidar")>
	<cftransaction>
		<cfif isdefined("Form.chk") and (Form.chk EQ 1 or Form.chk EQ 2)>
			<cfset lineas = ListToArray(Form.DOlinea, ',')>
			
			<!--- Si se seleccionó la opción de consolidar a nuevo tracking, se genera --->
			<cfif Form.chk eq 1>	
				<!--- Averiguar orden de compra del primer item --->
				<cfquery name="rsOrden" datasource="#rsCache.cncache#">
					select EOidorden
					from DOrdenCM
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCache.Ecodigo#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineas[1]#">
				</cfquery>
				
				<!--- Crear Tracking Vacio --->
				<cfinvoke 
				 component="sif.Componentes.CM_GeneraTracking"
				 method="generarNumTracking"
				 returnvariable="idtracking">
					<cfinvokeargument name="CEcodigo" value="#rsCache.CEcodigo#"/>
					<cfinvokeargument name="EcodigoASP" value="#rsCache.EcodigoASP#"/>
					<cfinvokeargument name="Ecodigo" value="#rsCache.Ecodigo#"/>
					<cfinvokeargument name="cncache" value="#rsCache.cncache#"/>
					<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
					<cfinvokeargument name="EOidorden" value="#rsOrden.EOidorden#"/>
				</cfinvoke>
			</cfif>
		
			<!--- Agregar ítems --->
			<cfif Form.chk eq 1>
				<cfset idtrackingdestino = idtracking>
			<cfelse>
				<cfset idtrackingdestino = Form.ETidtracking_move>
			</cfif>
			
			<cfset cambioDeLinea = "
			">
			<cfset consolidaciones = "">	<!--- Esta variable guarda los items y la cantidad consolidada de cada uno --->
			
			<cfloop from="1" to="#ArrayLen(lineas)#" index="i">
				<cfset codigo = lineas[i]>
				<!--- Se actualiza solo si se eligió consolidar una cantidad mayor a 0 --->
				<cfif Replace(Evaluate("Form.ETIcantidad_" & codigo), ',', '', 'all') gt 0>
					<!--- Se actualiza la línea --->
					<cfinvoke 
					 component="sif.Componentes.CM_GeneraTracking"
					 method="updTrackingItem"
					 returnvariable="LvarTrack">
						<cfinvokeargument name="Ecodigo" value="#rsCache.Ecodigo#"/>
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
						<cfinvokeargument name="ETidtracking" value="#Form.ETidtracking#"/>
						<cfinvokeargument name="DOlinea" value="#codigo#"/>
						<cfinvokeargument name="ETIcantidad" value="#Replace(Evaluate("Form.ETIcantidad_" & codigo), ',', '', 'all')#"/>
						<cfinvokeargument name="ETidtracking_new" value="#idtrackingdestino#"/>
						<cfinvokeargument name="cncache" value="#rsCache.cncache#"/>
					</cfinvoke>
					
					<!--- Se obtiene la descripción del item --->
					<cfquery name="datosItem" datasource="#rsCache.cncache#">
						select DOdescripcion
						from DOrdenCM
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCache.Ecodigo#">
						and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codigo#">
					</cfquery>
					
					<!--- Se agrega a la lista de items consolidados --->
					<cfset consolidaciones = consolidaciones & "#Evaluate("Form.ETIcantidad_" & codigo)# #datosItem.DOdescripcion#" & cambioDeLinea>
				</cfif>
			</cfloop>
			
			<cftransaction action="commit">
			
			<!--- Se genera una actividad de seguimiento para toda la consolidación, si es que hubo alguna --->
			<cfif Len(Trim(consolidaciones)) gt 0>
				<cfset consolidaciones = "Lista de artículos consolidados:" & cambioDeLinea & consolidaciones>

				<!--- Se obtiene el consecutivo del tracking destino --->				
				<cfquery name="datosTrackingNuevo" datasource="sifpublica">
					select ETconsecutivo
					from ETracking
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCache.Ecodigo#">
					and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idtrackingdestino#">
				</cfquery>

				<!--- Insertar una linea de seguimiento --->
				<cfquery name="insDTracking" datasource="sifpublica">
					insert into DTracking(ETidtracking, CEcodigo, EcodigoASP, Ecodigo, cncache, DTactividad, DTtipo, DTfecha, DTfechaincidencia, CRid, DTnumreferencia, ETcodigo, BMUsucodigo, Observaciones)
					select
						ETidtracking,
						CEcodigo,
						EcodigoASP,
						Ecodigo,
						cncache,
						'Consolidación a No. Tracking #datosTrackingNuevo.ETconsecutivo#',
						'C',
						<cf_dbfunction name="now">,
						<cf_dbfunction name="now">,
						CRid,
						ETnumreferencia,
						ETcodigo,
						#session.Usucodigo#,
						'#consolidaciones#'
					from ETracking
					where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
				</cfquery>
			</cfif>

			<!--- Chequear de que si el viejo tracking no queda con nigun item, hay que cerrarlo --->
			<cfquery name="checkTracking" datasource="sifpublica">
				select 1
				from ETrackingItems
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
					and ETIestado <> 1
					and ETIcantidad > 0
			</cfquery>
			<cfif checkTracking.recordCount EQ 0>
				<cfquery name="delTracking" datasource="sifpublica">
					update ETracking 
					set ETestado = 'E'
					where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
				</cfquery>
			</cfif>

			<!--- Consultar primera línea del Tracking Actual --->
			<cfquery name="rsItems" datasource="sifpublica">
				select DOlinea
				from ETrackingItems
				where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
			</cfquery>
			
			<cfif rsItems.recordCount GT 0>
				<!--- Averiguar orden de compra del primer item --->
				<cftransaction action="commit">
				<cfquery name="rsOrden" datasource="#rsCache.cncache#">
					select EOidorden
					from DOrdenCM
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCache.Ecodigo#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItems.DOlinea#">
				</cfquery>
				<!--- Actualizar la orden en el encabezado del Tracking --->
				<cftransaction action="commit">
				<cfquery name="updTracking" datasource="sifpublica">
					update ETracking 
					set EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.EOidorden#">
					where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>

<cfelseif isdefined("Form.Baja")>

	<cfquery name="delTrackingItems" datasource="sifpublica">
		delete from ETrackingItems
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
	</cfquery>

	<cfquery name="delTracking" datasource="sifpublica">
		delete from ETracking
		where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
	</cfquery>
	<cfset idtracking = 0>

</cfif>

<cfoutput>
<form action="trackingRegistro.cfm" method="post" name="sql">
<cfif not isdefined("Form.Nuevo") and isdefined("idtracking") and Len(Trim(idtracking)) and idtracking NEQ 0>
<input type="hidden" name="ETidtracking" value="#idtracking#">
</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
