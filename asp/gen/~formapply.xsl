<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://java.sun.com/jstl/xml"
	xmlns:c="http://java.sun.com/jstl/core"
	xmlns:fmt="http://java.sun.com/jstl/fmt"
	xmlns:sdc="http://soin.co.cr/taglibs/sdc-1.0"
	xmlns:jsp="http://java.sun.com/JSP/Page"
	xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:output method="xml"
		indent="yes"
		encoding="iso-8859-1"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://localhost/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	/>
	
	<!-- Paquete de definicion de queries en StdLogic -->
	<xsl:param name="pack" select="test.xx" />
    
    <xsl:template match="/">
		<jsp:root version="1.2">
			<jsp:directive.page contentType="text/html" />
			<html>
			<head>
				<title>Guardar <xsl:value-of select="table/name" /></title>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
				<link href="/jsp/util/e/design.css" rel="stylesheet" type="text/css" />
				<style type="text/css" >
					* {font-family:Verdana; font-size: 8pt;}
				</style>
			</head>
			<body>
				<xsl:apply-templates select="table" />
			</body>
			</html>
		</jsp:root>
    </xsl:template>
    
    <xsl:template match="table">
		<table width="100%" border="0" cellpadding="6">
		  <tr>
			<c:choose>
				<c:when test="${{not empty param.btnNuevo}}" >
					<td valign="top">Registro nuevo ... </td><td valign="top">
						<xsl:comment>No hacer nada, pasar al redirect posterior</xsl:comment>
					</td>
				</c:when>
				<c:when test="${{not empty param.btnEliminar}}" >
					<td valign="top">Eliminando registro ... </td><td valign="top">
						<sdc:logic query="{$pack}.{code}.del" output="xml">
							<xsl:for-each select="pk/key/cols/col">
								<sdc:argument name="{code}" value="${{param.{code}}}" />
							</xsl:for-each>
						</sdc:logic>
					</td>
				</c:when>
				<c:otherwise>
					<td valign="top">Guardando registro ... </td><td valign="top">
						<!-- convertir fechas -->
						<xsl:for-each select="cols/col[contains(type,'date')]">
							<xsl:comment> convertir <xsl:value-of select="code" /> a fecha </xsl:comment>
							<fmt:parseDate pattern="d/M/y" value="${{param.{code}}}" var="__date__{code}" />
						</xsl:for-each>
						<sdc:logic query="{$pack}.{code}.upd" output="xml">
							<xsl:for-each select="cols/col">
								<xsl:choose>
									<xsl:when test="contains(type,'date')">
										<sdc:argument name="{code}" value="${{__date__{code}}}" />
									</xsl:when>
									<xsl:otherwise>
										<sdc:argument name="{code}" value="${{param.{code}}}" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</sdc:logic>
						<c:redirect url="{code}.jsp">
							<xsl:for-each select="pk/key/cols/col">
								<c:param name="{code}" value="${{param.{code}}}" />
							</xsl:for-each>
						</c:redirect>
						<jsp:text>[ </jsp:text><a href="{code}.jsp">Regresar a lista</a><jsp:text> ]</jsp:text>
					</td>
				</c:otherwise>
			</c:choose>
		  </tr>
		</table>
		<br />
		<c:redirect url="{code}.jsp" />
		<jsp:text>[ </jsp:text><a href="{code}.jsp">Regresar a lista</a><jsp:text> ]</jsp:text>
    </xsl:template>
    
</xsl:stylesheet>