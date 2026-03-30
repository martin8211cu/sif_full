<cfif not isdefined("Form.Nuevo")>
	<cfif IsDefined("form.insertarCF")>
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset rsUsuario = sec.getUsuarioByRef (Form.CMSid, session.EcodigoSDC, 'CMSolicitantes')>
	<cftransaction>
		<cf_dbfunction name='OP_concat' returnvariable='concat'>
		<cfquery name="rsCentros" datasource="#session.DSN#" >
			select distinct 
			a.CFid as CFpk,a.CFpath, a.CFcodigo, a.CFnivel
			from  CFuncional a
			where a.Ecodigo  = #session.Ecodigo#
              and a.CFestado = 1 <!---Solo Activos--->
			and a.CFid not in 
				( 
				select  a.CFid 
					from CMSolicitantesCF a 
						inner join CFuncional b 
							on b.CFid = a.CFid
					where a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">
				)
			order by a.CFpath, a.CFcodigo, a.CFnivel
		</cfquery>
		
		<cfloop query="rsCentros" >
		
			<cfquery name="insertd"  datasource="#session.dsn#">
					insert into CMSolicitantesCF ( CFid, CMSid, Usucodigo, CMSCFfecha,BMUsucodigo )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentros.CFpk#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">,
							 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
							 #Session.Usucodigo#
							 )
			</cfquery>
			<!--- Inserta por default al Solicitante de Compras como Solicitante de Solicitudes de Pago de Tesorería para el Centro Funcional --->
			<!---si por alguna razon falla aqui en la parte del #rsUsuario.Usucodigo# se debe a que los solicitantes de la tabla CMSolicitantes no estan en la 
			de asp..UsuarioReferencia por lo cual segun don oscar eso esta mal y se debe a que fueron agregados por debajo .
			select count(1) from asp..UsuarioReferencia where STabla='CMSolicitantes'
			select count(1) from CMSolicitantes : estos son la lista de solicitantes del paso 1--->
	
			<cfquery name="insert" datasource="#session.DSN#">
					insert into TESusuarioSP 
						(
							 CFid
							,Usucodigo
							,Ecodigo
							,TESUSPsolicitante
							,BMUsucodigo
						)
					select 
							 cf.CFid
							,#rsUsuario.Usucodigo#
							,cf.Ecodigo
							,1
							,#session.Usucodigo#
					  from CFuncional cf
					 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentros.CFpk#">
					   and not exists (
									select 1
									  from TESusuarioSP
									 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentros.CFpk#">
									   and Usucodigo = #rsUsuario.Usucodigo#
								)
				</cfquery>
			
		</cfloop>						
	</cftransaction>						
	</cfif>
	
	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp")>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset rsUsuario = sec.getUsuarioByRef (Form.CMSid, session.EcodigoSDC, 'CMSolicitantes')>
		<cftransaction>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into CMSolicitantesCF ( CFid, CMSid, Usucodigo, CMSCFfecha, BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuario.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 #session.Usucodigo#
						 )
			</cfquery>
			
			<!--- Inserta por default al Solicitante de Compras como Solicitante de Solicitudes de Pago de Tesorería para el Centro Funcional --->
			<cfquery name="insert" datasource="#session.DSN#">
				insert into TESusuarioSP 
					(
						 CFid
						,Usucodigo
						,Ecodigo
						,TESUSPsolicitante
						,BMUsucodigo
					)
				select 
						 cf.CFid
						,#rsUsuario.Usucodigo#
						,cf.Ecodigo
						,1
						,#session.Usucodigo#
				  from CFuncional cf
				 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
				   and not exists (
								select 1
								  from TESusuarioSP
								 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
								   and Usucodigo = #rsUsuario.Usucodigo#
							)
			</cfquery>
		</cftransaction>
	<cfelseif isdefined("Form.Baja") and #Form.Baja# eq 1>
		<cfquery name="select_before_delete" datasource="#session.DSN#">
			select 1
			from CMESolicitantes a
			inner join CMEspecializacionTSCF b
				on a.CMElinea = b.CMElinea
				and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
			where a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">
		</cfquery>
		<cfif select_before_delete.RecordCount>
			<cf_errorCode	code = "50266" msg = "El Centro Funcional no puede ser eliminado porque existen especializaciones dependientes, Proceso Cancelado!">
		</cfif>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CMSolicitantesCF
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
				and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">
		</cfquery>
	</cfif>

</cfif><!---Form.Nuevo--->
<cfif isdefined("form.AltaEsp")>
	<cfset Session.Compras.Solicitantes.Pantalla = Session.Compras.Solicitantes.Pantalla + 1>
</cfif>
<cflocation url="solicitantes.cfm">

