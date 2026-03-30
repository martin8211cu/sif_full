<cfif isdefined('form.btnBorrar')>
	<cfif isDefined("form.CHK")>	
		<cfquery name="rsLogines" datasource="#session.dsn#">
			Select tp.Contratoid
				, tp.LGnumero
				, lo.LGlogin
				, tp.TPid
				, tp.TPdescripcion
			from ISBtareaProgramada tp
				left outer join ISBlogin lo
					on lo.LGnumero=tp.LGnumero
						and lo.Contratoid=tp.Contratoid
			where tp.Contratoid is not null
				and tp.LGnumero is not null
				and tp.TPid in (#form.CHK#)
		</cfquery>

		<cftransaction>
			<cfset arreglo = listtoarray(form.CHK,",")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
 				<cfinvoke component="saci.comp.ISBtareaProgramada"
					method="Baja">
					<cfinvokeargument name="TPid" value="#arreglo[i]#">
				</cfinvoke>		
				
				<cfif isdefined('rsLogines') and rsLogines.recordCount GT 0>
					<cfquery name="rsLoginesInd" dbtype="query">
						select Contratoid
								, LGnumero
								, LGlogin
						from rsLogines
						where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#" null="#Len(arreglo[i]) Is 0#">
					</cfquery>
					
					<cfif isdefined('rsLoginesInd') and rsLoginesInd.recordCount GT 0>
						<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">		<!---registro en la bitacora del borrado realizado --->
							<cfinvokeargument name="LGnumero" value="#rsLoginesInd.LGnumero#">
							<cfinvokeargument name="LGlogin" value="#rsLoginesInd.LGlogin#">
							<cfinvokeargument name="BLautomatica" value="false">				
							<cfinvokeargument name="BLobs" value="Borrado de Tarea Programada Manualmente en la consulta de Tareas Programadas por Cliente. (#rsLoginesInd.TPdescripcion#)">
							<cfinvokeargument name="BLfecha" value="#now()#">
						</cfinvoke>					
					</cfif>
				</cfif>
			</cfloop>
		</cftransaction>
	</cfif>
</cfif>

<cflocation url="tareasProg.cfm">