<cfsetting enablecfoutputonly="yes">
<cfparam name="url.dft" default="blank">
<cfparam name="url.tid" type="numeric">
<cfparam name="url.id" type="numeric">
<cfparam name="url.fid" default="">
<cfparam name="url.sz" default="sm"> <!--- sm=small, nr=normal, or=original --->
<cfif ListFind('sm,nr,or',url.sz) Is 0>
	<cfthrow message="Invalid url.sz:#HTMLEditFormat(url.sz)# in producto_img.cfm">
</cfif>
<cfif url.sz is 'sm'>
	<cfset dbfield = 'img_small'>
	<cfset RequiredHeight = 60>
	<cfset RequiredMinWidth = 30>
	<cfset RequiredMaxWidth = 90>
<cfelseif url.sz is 'nr'>
	<cfset dbfield = 'img_normal'>
	<cfset RequiredHeight = 240>
	<cfset RequiredMinWidth = 120>
	<cfset RequiredMaxWidth = 360>
<cfelse>
	<cfset dbfield = 'img_foto'>
	<cfset RequiredHeight = 0>
	<cfset RequiredMaxWidth = 360>
</cfif>
<cfquery datasource="#session.dsn#" name="rs">
	set rowcount 1
	select #dbfield# as imagen,
		datalength(img_foto) as length_img_foto, id_foto
	from FotoProducto
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tid#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	<cfif Len(url.fid)>
	  and id_foto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fid#">
	</cfif>
	set rowcount 0
</cfquery>
<cfif rs.RecordCount EQ 0>
	<cfif url.dft EQ 'na'>
		<cflocation url="../images/not_avail.gif">
	<cfelseif url.dft EQ 'empty'>
		<cfoutput>Imagen no disponible</cfoutput>
	<cfelse><!--- url.dft EQ blank --->
		<cflocation url="../images/blank.gif">
	</cfif>
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cfif Len(rs.imagen) Is 0 And rs.length_img_foto Neq 0 And RequiredHeight Neq 0>
		<cfquery datasource="#session.dsn#" name="original">
			select img_foto
			from FotoProducto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tid#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			  and id_foto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.id_foto#">
		</cfquery>
		<cffile action="write" file="#tempfile#" output="#original.img_foto#" >
		<cfscript>
			image = createObject("component","tienda.Componentes.ImageJ.ImageJ");
			binary = createObject("component", "tienda.Componentes.ReadBinary");
			image.open(tempfile);
			originalType = image.getType();
			originalWidth = image.getWidth();
			originalHeight = image.getHeight();
			ratio = originalWidth / originalHeight;
			if (ratio LT 0.5) { // mucho mas alto que ancho (|)
				image.resize(RequiredMinWidth, 'width');
				image.setRoi(0, 0, RequiredMinWidth, RequiredHeight);
				image.crop();
			} else if (ratio GT 1.5) { // mucho mas ancho que alto (-)
				image.resize(RequiredHeight, 'height');
				image.setRoi(0, 0, RequiredMaxWidth, RequiredHeight);
				image.crop();
			} else {
				image.resize(RequiredHeight, 'height');
			}
			image.saveAs(tempfile);
		</cfscript>
		<cflog file="image_resize" text="Image #rs.id_foto#, ratio = #ratio# (w=#originalWidth#,h=#originalHeight#)">
		<cffile action="readbinary" file="#tempfile#" variable="tmp" >
		<cfquery datasource="#session.dsn#">
			update FotoProducto
			set #dbfield# = #binary.BinaryString(tmp)#
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tid#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			  and id_foto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.id_foto#">
		</cfquery>
	<cfelse>
		<cffile action="write" file="#tempfile#" output="#rs.imagen#" >
	</cfif>
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>