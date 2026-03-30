<!---
	<cf_fsfunction name="getVolumeSpace" args="path">
---> 
<cfcomponent>
	<!---  Funcion que devuelve un el espacio total, usado y disponible del volumen de un path --->
	<cffunction name="getVolumeSpace" returnType="struct" output="false" access="public">
		<cfargument name="Path" default="">
		
		<cfset var LvarRoot = expandPath("/")>
		<cfif Arguments.Path EQ "">
			<cfset Arguments.Path = LvarRoot>
		</cfif>
		<cfif findNoCase(mid(Arguments.Path,1,len(LvarRoot)), LvarRoot) NEQ 1>
			<cfset Arguments.Path = expandPath(Arguments.Path)>
		</cfif>

		<cfset Arguments.Path = GetDirectoryFromPath(Arguments.Path)>
		<cfif not DirectoryExists(Arguments.Path)>
			<cf_errorCode	code = "51177"
							msg  = "El directorio indicado no existe: @errorDat_1@"
							errorDat_1="#Arguments.Path#"
			>
		</cfif>
		<cfif findNoCase("windows", server.OS.Name)>
			<!---
			WINDOWS: Scripting.FileSystemObject
			--->
			<cfset fso_is_initialized = False>
			<cflock scope="application" type="readonly" timeout="120">
				<cfset fso_is_initialized = StructKeyExists(Application, "fso")>
			</cflock>
			<cfif not fso_is_initialized >
				<cflock scope="Application" type="EXCLUSIVE" timeout="120">
					<cfif NOT StructKeyExists(Application, "fso")>
						<cfobject 	type="COM" action="create" class="Scripting.FileSystemObject"
									name="Application.fso" server="\\localhost">
					</cfif>
				</cflock>
			</cfif>
		
			<cfset LvarDriveName=Application.fso.getDriveName(Arguments.Path)>
			<cfset LvarDrive=Application.fso.getDrive(LvarDriveName)>
			<cfset LvarResult=StructNew()>
			<cfset LvarResult.Volume		= LvarDrive.DriveLetter>
			<cfset LvarResult.Total			= LvarDrive.TotalSize>
			<cfset LvarResult.Available		= LvarDrive.AvailableSpace>
			<cfset LvarResult.Used			= LvarResult.Total-LvarResult.Available>
		<cfelse>
			<!---
			UNIX/LINUX: df -k -P path
				AIX$ df -k -P .
				Filesystem         1024-blocks      Used Available Capacity Mounted on
				/dev/lv04             11534336   5753700   5780636      50% /usr/WebSphere
				
				LINUX$ df -k -P .
				Filesystem         1024-blocks      Used Available Capacity Mounted on
				/dev/sdb1             35001508  32475728    747788      98% /
			--->
			<cfset LvarOut = "">
			<cfexecute name="df" arguments="-k -P #Arguments.Path#" variable="LvarOut" timeout="10" />
			<cfset LvarLineas = listToArray(LvarOut,chr(10))>
			<cfset LvarColumnas = listToArray(LvarLineas[2]," ")>
			<cfset LvarResult=StructNew()>
			<cfset LvarResult.Volume		= LvarColumnas[1]>
			<cfset LvarResult.Total			= LvarColumnas[2]>
			<cfset LvarResult.Used			= LvarColumnas[3]>
			<cfset LvarResult.Available		= LvarColumnas[4]>
		</cfif>
	
		<cfset LvarResult.Path			= Arguments.path>
		<cfreturn LvarResult>
	</cffunction>
</cfcomponent>


