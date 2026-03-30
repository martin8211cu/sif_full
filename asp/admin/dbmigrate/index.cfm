<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Current_datasource = t.Translate('Current_datasource','El origen de datos actual es','/TableDefinition.xml')>
<cfset Current_datasource_v = t.Translate('Current_datasource_v ','La versi&oacuten actual de la base de datos es','/TableDefinition.xml')>
<cfset Avaliable_Updates = t.Translate('Avaliable_Updates ','Actualizaciones disponibles','/TableDefinition.xml')>
<cfset Updates = t.Translate('Updates ','Actualizaciones','/TableDefinition.xml')>
<cfset Datasource = t.Translate('Datasource ','Origen de Datos','/TableDefinition.xml')>
<cfset Migrate = t.Translate('Migrate ','Migrar','/TableDefinition.xml')>
<cfset Migrate_v = t.Translate('Migrate_v','Migrar a versi&oacuten','/TableDefinition.xml')>
<cfset All_not_migrated = t.Translate('All_not_migrated','Todos no migrados','/TableDefinition.xml')>
<cfset Empty = t.Translate('Empty','Vacio','/TableDefinition.xml')>
<cfset Not_migrated = t.Translate('Not_migrated','No migrado','/TableDefinition.xml')>
<cfset Available_migrations = t.Translate('Available_migrations','Migraciones Disponibles','/TableDefinition.xml')>
<cfset New_file_migration = t.Translate('New_file_migration','Crear un nuevo archivo de migraci&oacuten desde plantilla','/TableDefinition.xml')>
<cfset Select_template = t.Translate('Select_template','Seleccionar Plantilla','/TableDefinition.xml')>
<cfset Migration_description = t.Translate('Migration_description','Descripci&oacuten de la migraci&oacuten','/TableDefinition.xml')>
<cfset Example = t.Translate('Example','Ejem. Crea tabla de miembros','/TableDefinition.xml')>
<cfset Create = t.Translate('Create','Crear','/TableDefinition.xml')>
<cfset Blank_migration  = t.Translate('Blank_migration','Migraci&oacuten en blanco','/TableDefinition.xml')>
<cfset Table_Operations = t.Translate('Table_Operations','Operaciones de tabla','/TableDefinition.xml')>
<cfset Create_table  = t.Translate('Create_table','Crear Tabla','/TableDefinition.xml')>
<cfset Change_table_multi  = t.Translate('Change_table_multi','Modificar Tabla (Multi-Columna)','/TableDefinition.xml')>
<cfset Rename_table  = t.Translate('Rename_table','Renombrar Tabla','/TableDefinition.xml')>
<cfset Remove_table  = t.Translate('Remove_table','Remover Tabla','/TableDefinition.xml')>
<cfset Column_Operations  = t.Translate('Column_Operations','Operaciones de Columna','/TableDefinition.xml')>
<cfset Create_single_column  = t.Translate('Create_single_column','Crear Columna Simple','/TableDefinition.xml')>
<cfset Change_single_column  = t.Translate('Change_single_column','Cambiar Columna Simple','/TableDefinition.xml')>
<cfset Rename_single_column  = t.Translate('Rename_single_column','Renombrar Columna Simple','/TableDefinition.xml')>
<cfset Remove_single_column  = t.Translate('Remove_single_column','Remover Columna Simple','/TableDefinition.xml')>
<cfset Index_Operations = t.Translate('Index_Operations','Operaciones de Index','/TableDefinition.xml')>
<cfset Create_index  = t.Translate('Create_index','Crear Index','/TableDefinition.xml')>
<cfset Remove_index  = t.Translate('Remove_index','Remover Index','/TableDefinition.xml')>
<cfset Record_Operations  = t.Translate('Record_Operations','Operaciones de Registros','/TableDefinition.xml')>
<cfset Create_record  = t.Translate('Create_record','Crear Registro','/TableDefinition.xml')>
<cfset Update_record  = t.Translate('Update_record','Actualizar Registro','/TableDefinition.xml')>
<cfset Remove_record = t.Translate('Remove_record','Remover Registro','/TableDefinition.xml')>
<cfset Miscellaneous_operations = t.Translate('Miscellaneous_operations','Operaciones Varias','/TableDefinition.xml')>
<cfset Announce_operation = t.Translate('Announce_operation','Anunciar la Operaci&oacuten','/TableDefinition.xml')>
<cfset Execute_operation  = t.Translate('Execute_operation','Ejecutar la Operaci&oacuten','/TableDefinition.xml')>
<cfset Upload_definition = t.Translate('upload importer definition', 'Cargar Definici&oacute;n de Importador', '/TableDefinition.xml')>
<cfset Migrated  = t.Translate('Migrated','Migrado','/TableDefinition.xml')>
<cf_templateheader title="Version Base de Datos">

<cf_web_portlet_start titulo="Version Base de Datos">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfhtmlhead text='<link href="/cfmx/jquery/estilos/jquery.modallink/jquery.modalLink-1.0.0.css" rel="stylesheet" type="text/css" />'>
<cfhtmlhead text='<script type="text/javascript" language="JavaScript" src="/cfmx/jquery/librerias/jquery.modallink/jquery.modalLink-1.0.0.js">//</script>'>

<cfinclude template="flash.cfm" >

<cfset objdbmigrate	= createObject( "component","asp.admin.dbmigrate.dbmigrate")>

<cfset arrCaches = ArrayNew(1)>

<cflock name="serviceFactory" type="exclusive" timeout="10">
 <cfscript>
	 factory = CreateObject("java", "coldfusion.server.ServiceFactory");
	 ds_service = factory.datasourceservice;
   </cfscript>
 <!--- obtiene los nombres de los datasources --->
 <cfset caches = ds_service.getNames()>



 <!--- obtiene un struct con la propiedades de los datasources --->
 <!---<cfset ds = "#ds_service.getDataSources()#" >--->
 <cfinvoke	component="home.Componentes.DbUtils"
 			method="getColdfusionDatasources"
			DS_Service="#ds_service#"
			returnvariable="ds"
			>

 <!--- Crea un arreglo con los datasources validos --->
 <!--- No toma en cuanta los datasources de MSaccess, pues son defindiso por el cf
	   para ejemplos y otros motivos y no corresponden a las aplicaciones nuestras
 --->

 <cfset j = 1 >
<cftry>
 <cfloop From="1" To="#ArrayLen(caches)#" index="i">
  <cfset data = "ds." & caches[i] & ".driver" >

  <cfif UCase(Evaluate(data)) eq 'MSSQLServer'>
  	<cfset datasources[j] = caches[i] >
   <cfset j = j +1 >
  </cfif>
 </cfloop>
<cfcatch type="any" >

</cfcatch>
</cftry>
 <cfset ArraySort(datasources, "text") >
</cflock>

<cfparam  name="ccache" default="">
<!--- Get current database version --->
<cfif isdefined("form.ccache")>
	<cfset ccache = form.ccache>
</cfif>

<cfset dbmigrateMeta = {}>
<cfset dbmigrateMeta.version = "0.9">
<cfif isDefined("Form.version")>

	<cfset request.dataSourceUserName = form.userName>
	<cfset request.dataSourcePassword = form.pass>

	<cfset flashInsert(dbmigrateFeedback=objdbmigrate.migrateTo(Form.version,ccache,isDefined('form.stragglers')))>
	<!--- <cflocation url="index.cfm"> --->
<cfelseif isDefined("Form.migrationName")>
	<cfparam name="Form.templateName" default="">
	<cfparam name="Form.migrationPrefix" default="">
	<cfset flashInsert(dbmigrateFeedback2=objdbmigrate.createMigration(Form.migrationName,Form.templateName,Form.migrationPrefix,form.ccache))>
	<!--- <cflocation url="index.cfm"> --->
<cfelseif isDefined("url.migrateToVersion") And Len(Trim(url.migrateToVersion)) GT 0 And IsNumeric(url.migrateToVersion)>
  <cfif isDefined("url.password") And Trim(url.password) EQ application.wheels.reloadPassword>
  	<cfset flashInsert(dbmigrateFeedback=objdbmigrate.migrateTo(url.migrateToVersion))>
  	<!--- <cflocation url="index.cfm"> --->
  </cfif>
</cfif>

<cfset currentVersion = objdbmigrate.getCurrentMigrationVersion(ccache)>

<!--- Get current list of migrations --->
<cfset migrations = objdbmigrate.getAvailableMigrations(ccache)>
<cfif ArrayLen(migrations)>
	<cfset lastVersion = migrations[ArrayLen(migrations)].version>
<cfelse>
	<cfset lastVersion = 0>
</cfif>

<cfoutput>
<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td width="60%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
						<strong><h3>DBMigrate v#dbmigrateMeta.version#</h3></strong>
					</td>
				</tr>
				<cfif flashKeyExists("dbmigrateFeedback")>
				<tr>
					<td>
						<h2>Migration result</h2>
						<pre>#flash("dbmigrateFeedback")#</pre>
					</td>
				</tr>
				</cfif>
				<tr>
					<td class="subTitulo  tituloListas">
						<strong>#Datasource#</strong>
					</td>
				</tr>
				<tr>
					<td>
						<table >
							<tr>
								<td nowrap>#Current_datasource#</td>
								<td width="1%">
								<td>
									<form name="frmCache" action="#CGI.script_name & '?' & CGI.query_string#" method="post">
										<select name="Ccache" onchange="this.form.submit()">
											<option value=""> -- Seleccionar -- </option>
											<cfloop index="ds" from="1" to="#ArrayLen(datasources)#">
												<cfquery name="caches"  datasource="asp">
													select Ccache
													from Caches
													where Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datasources[ds]#">
												</cfquery>

												<cfif caches.RecordCount neq 0 or listfind("asp,aspmonitor,sifcontrol,sifpublica,sifinterfaces",datasources[ds]) gt 0>
													<option value="#datasources[ds]#"
														<cfif isdefined("form.ccache") and form.ccache eq datasources[ds]> selected </cfif>>
														#datasources[ds]#
													</option>
												</cfif>
											</cfloop>
										</select>
									</form>
								</td>
							</tr>
							<tr>
								<td nowrap>#Current_datasource_v#</td>
								<td width="1%">
								<td><strong>#currentVersion#</strong></td>
							</tr>
						</table>
					</td>
				</tr>
				<cfif ArrayLen(migrations) gt 0>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="subTitulo  tituloListas">
						<strong>#Migrate#</strong>
					</td>
				</tr>
				<tr>
					<td>

						<form name="frmigrate" action="#CGI.script_name & '?' & CGI.query_string#" method="post">
							<input type="hidden" name="ccache" value="#ccache#">
							<input type="hidden" name="userName" value="">
							<input type="hidden" name="pass" value="">
							<p>#Migrate_v#
								<cfset migrations_stragglers = 0 >
								<cfset migrations_pending = 0 >
								<select name="version">#CGI.script_name#
									<cfif lastVersion neq 0><option value="#lastVersion#" selected="selected">#All_not_migrated#</option></cfif>
									<cfif currentVersion neq "0"><option value="0">0 - #Empty#</option></cfif>
									<cfloop array="#migrations#" index="migration">
										<option value="#migration.version#">#migration.version# - #migration.name# <cfif migration.status eq "migrated">(#Migrated#)<cfelse>(#Not_migrated#)</cfif></option>
										<cfscript>
											if (migration.status == 'migrated') { 
												migrations_stragglers += migrations_pending; 
												migrations_pending = 0;
											} else {
												migrations_pending++;
											}
										</cfscript>
									</cfloop>
								</select>
								<cfif migrations_stragglers gt 0 >
								<label><input type="checkbox" value="stragglers">Incluir las #migrations_stragglers# migraciones rezagada(s)</label></cfif>
								<input id="btnGo" name="btnGo" type="button" value="go">
							</p>
						</form>
						<div id="dialog-form" title="Credentials for datasource #ccache#">
							<p class="validateTips">All form fields are required.</p>
							<form name="frmSecurity">
								<fieldset style="align:left">
									<label for="name">Username</label>
									<input type="text" name="name" id="name" class="text">
									<br />
									<label for="password">Password</label>
									<input type="password" name="password" id="password" value="" class="text">
									<br />
									<input id="btnOk" name="btnOk" type="button" value="ok" onclick="funcSubmitMigration()">
								</fieldset>
							</form>
						</div>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="subTitulo  tituloListas">
						<strong>#Available_migrations#</strong>
					</td>
				</tr>
				<tr>
					<td>
						<!--- List migrations available --->
						<p>
							<cfloop array="#migrations#" index="migration">
								<span<cfif migration.status eq "migrated"> style="font-weight:bold;"</cfif>>
									#migration.version# - #migration.name#
									<cfif migration.loadError neq ""> (load error: #migration.loadError#)</cfif>
									<cfif migration.details neq ""> (#migration.details#)</cfif>
									- <em>
										<cfif migration.status eq "migrated">
											#Migrated#
										<cfelse>
											#Not_migrated#
										</cfif>
									</em>
								</span><br />
							</cfloop>
						</p>
					</td>
				</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
			</table>
			<cfif len(trim(ccache))>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td class="subTitulo  tituloListas">
						<strong>#New_file_migration#</strong>
					</td>
				</tr>
				<tr>
					<td>
						<cfif flashKeyExists("dbmigrateFeedback2")>
							<pre style="margin-top:10px;">#flash("dbmigrateFeedback2")#</pre>
						</cfif>
						<form action="#CGI.script_name & '?' & CGI.query_string#" method="post">
							<input type="hidden" name="ccache" value="#ccache#">
							<table>
								<tr>
									<td nowrap>#Select_template#</td>
									<td width="1%">
									<td>
										<select name="templateName">
											<option value="blank">#Blank_migration#</option>
											<option value="">-- #Table_Operations# --</option>
											<option value="create-table">#Create_table#</option>
											<option value="change-table">#Change_table_multi#</option>
											<option value="rename-table">#Rename_table#</option>
											<option value="remove-table">#Remove_table#</option>
											<option value="">-- #Column_Operations# --</option>
											<option value="create-column">#Create_single_column#</option>
											<option value="change-column">#Change_single_column#</option>
											<option value="rename-column">#Rename_single_column#</option>
											<option value="remove-column">#Remove_single_column#</option>
											<option value="">-- #Index_Operations# --</option>
											<option value="create-index">#Create_index#</option>
											<option value="remove-index">#Remove_index#</option>
											<option value="">-- #Record_Operations# --</option>
											<option value="create-record">#Create_record#</option>
											<option value="update-record">#Update_record#</option>
											<option value="remove-record">#Remove_record#</option>
											<option value="">-- #Miscellaneous_operations# --</option>
											<option value="announce">#Announce_operation#</option>
											<option value="execute">#Execute_operation#</option>
											<option value="upload-importerDefinition">#Upload_definition#</option>
										</select>
									</td>
								</tr>
								<cfif ArrayLen(migrations) eq 0>
								<tr>
									<td nowrap>Migration prefix</td>
									<td width="1%">
									<td>
										<select name="migrationPrefix">
											<option value="timestamp">Timestamp (e.g. #dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#)</option>
											<option value="numeric">Numeric (e.g. 001)</option>
										</select>
									</td>
								</tr>
								</cfif>
								<tr>
									<td nowrap>#Migration_description#</td>
									<td width="1%">
									<td>
										<input name="migrationName" type="text" size="30">
										#Example#</p>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<p><input type="submit" value="#Create#"></p>
									</td>
								</tr>
							</table>
						</form>
					</td>
				</tr>
			</table>
			</cfif>
		</td>
		<td valign="top">
		<form name="frmAvaliable" action="#CGI.script_name & '?' & CGI.query_string#" method="post">
			<input type="hidden" name="ccache" value="">
			<table width="95%" align="center" cellspacing="2">
			<th>
				<a href="help/Manual dbmigrate v.3.pdf" target="_blank">Ayuda<img src="help/ayuda.png" heigth="20px" width="20px">
			</a>
			</tr>
				<tr>
					<th>#Avaliable_Updates#</th>
				</tr>
				<cfloop index="ds" from="1" to="#ArrayLen(datasources)#">
					<cfquery name="caches"  datasource="asp">
						select Ccache
						from Caches
						where Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datasources[ds]#">
					</cfquery>
					<cfif caches.RecordCount neq 0 or listfind("asp,aspmonitor,sifcontrol,sifpublica,sifinterfaces",datasources[ds]) gt 0>
						<cfset dsmigrations=objdbmigrate.getAvailableMigrations(datasources[ds])>
						<cfset avaliblecount = 0>
						<cfif ArrayLen(dsmigrations)>
							<cfloop index="cs" from="1" to="#ArrayLen(dsmigrations)#">
								<cfif dsmigrations[cs].status neq "migrated">  <cfset avaliblecount =avaliblecount + 1>  </cfif>
							</cfloop>
						</cfif>
						<tr>
							<td>
								<cfif avaliblecount gt 0><b></cfif>
								<span style="cursor:pointer" onclick="funcSubmit('#datasources[ds]#')">#datasources[ds]# - (#avaliblecount#) #Updates#</span>
								<cfif avaliblecount gt 0></b></cfif>
							</td>
						</tr>

					</cfif>

				</cfloop>

			</table>
		</td>
		</td>
	</tr>
</table>

<script>
	function funcSubmit(cache){
		document.frmAvaliable.ccache.value = cache;
		document.frmAvaliable.submit();
	}

	function funcSubmitMigration(){
		document.frmigrate.userName.value = document.frmSecurity.name.value;
		document.frmigrate.pass.value = document.frmSecurity.password.value;
		document.frmigrate.submit();
	}
</script>

<script>

	$("##dialog-form").dialog({
	    autoOpen : false, modal : true, show : "blind", hide : "blind"
	});
</script>
<script>
	$( "##btnGo" ).click(function() {
        $('##dialog-form').dialog("open");
        return false;
    });
</script>

<script>
	$(function () {

	        $(".modal-link").modalLink({
		        title: '',
		        height: 550,
				width: 900
		    });

	});
</script>

</cfoutput>
<cfset flashClear()>


<cf_web_portlet_end>
<cf_templatefooter>

