// Machine generated IDispatch wrapper class(es) created by Microsoft Visual C++

// NOTE: Do not modify the contents of this file.  If this class is regenerated by
//  Microsoft Visual C++, your modifications will be overwritten.


#include "stdafx.h"
#include "ijactrl.h"

/////////////////////////////////////////////////////////////////////////////
// CIjaCtrl

IMPLEMENT_DYNCREATE(CIjaCtrl, CWnd)

/////////////////////////////////////////////////////////////////////////////
// CIjaCtrl properties

unsigned long CIjaCtrl::GetTransactionDelete()
{
	unsigned long result;
	GetProperty(0x1, VT_I4, (void*)&result);
	return result;
}

void CIjaCtrl::SetTransactionDelete(unsigned long propVal)
{
	SetProperty(0x1, VT_I4, propVal);
}

unsigned long CIjaCtrl::GetTransactionInsert()
{
	unsigned long result;
	GetProperty(0x2, VT_I4, (void*)&result);
	return result;
}

void CIjaCtrl::SetTransactionInsert(unsigned long propVal)
{
	SetProperty(0x2, VT_I4, propVal);
}

unsigned long CIjaCtrl::GetTransactionAfterUpdate()
{
	unsigned long result;
	GetProperty(0x3, VT_I4, (void*)&result);
	return result;
}

void CIjaCtrl::SetTransactionAfterUpdate(unsigned long propVal)
{
	SetProperty(0x3, VT_I4, propVal);
}

unsigned long CIjaCtrl::GetTransactionBeforeUpdate()
{
	unsigned long result;
	GetProperty(0x4, VT_I4, (void*)&result);
	return result;
}

void CIjaCtrl::SetTransactionBeforeUpdate(unsigned long propVal)
{
	SetProperty(0x4, VT_I4, propVal);
}

unsigned long CIjaCtrl::GetTransactionOther()
{
	unsigned long result;
	GetProperty(0x5, VT_I4, (void*)&result);
	return result;
}

void CIjaCtrl::SetTransactionOther(unsigned long propVal)
{
	SetProperty(0x5, VT_I4, propVal);
}

BOOL CIjaCtrl::GetPaintForegroundTransaction()
{
	BOOL result;
	GetProperty(0x6, VT_BOOL, (void*)&result);
	return result;
}

void CIjaCtrl::SetPaintForegroundTransaction(BOOL propVal)
{
	SetProperty(0x6, VT_BOOL, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// CIjaCtrl operations

void CIjaCtrl::SetMode(short nMode)
{
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x7, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nMode);
}

long CIjaCtrl::AddUser(LPCTSTR strUser)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x8, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		strUser);
	return result;
}

void CIjaCtrl::CleanUser()
{
	InvokeHelper(0x9, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void CIjaCtrl::RefreshPaneDatabase(LPCTSTR lpszNode, LPCTSTR lpszDatabase, LPCTSTR lpszDatabaseOwner)
{
	static BYTE parms[] =
		VTS_BSTR VTS_BSTR VTS_BSTR;
	InvokeHelper(0xa, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszNode, lpszDatabase, lpszDatabaseOwner);
}

void CIjaCtrl::RefreshPaneTable(LPCTSTR lpszNode, LPCTSTR lpszDatabase, LPCTSTR lpszDatabaseOwner, LPCTSTR lpszTable, LPCTSTR lpszTableOwner)
{
	static BYTE parms[] =
		VTS_BSTR VTS_BSTR VTS_BSTR VTS_BSTR VTS_BSTR;
	InvokeHelper(0xb, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszNode, lpszDatabase, lpszDatabaseOwner, lpszTable, lpszTableOwner);
}

void CIjaCtrl::SetUserPos(long nPos)
{
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0xc, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nPos);
}

void CIjaCtrl::SetUserString(LPCTSTR lpszUser)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0xd, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszUser);
}

void CIjaCtrl::SetAllUserString(LPCTSTR lpszAllUser)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0xe, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszAllUser);
}

void CIjaCtrl::AddNode(LPCTSTR lpszNode)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0xf, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszNode);
}

void CIjaCtrl::RemoveNode(LPCTSTR lpszNode)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x10, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszNode);
}

void CIjaCtrl::CleanNode()
{
	InvokeHelper(0x11, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

short CIjaCtrl::GetMode()
{
	short result;
	InvokeHelper(0x12, DISPATCH_METHOD, VT_I2, (void*)&result, NULL);
	return result;
}

void CIjaCtrl::EnableRecoverRedo(BOOL bEnable)
{
	static BYTE parms[] =
		VTS_BOOL;
	InvokeHelper(0x13, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 bEnable);
}

BOOL CIjaCtrl::GetEnableRecoverRedo()
{
	BOOL result;
	InvokeHelper(0x14, DISPATCH_METHOD, VT_BOOL, (void*)&result, NULL);
	return result;
}

long CIjaCtrl::ShowHelp()
{
	long result;
	InvokeHelper(0x15, DISPATCH_METHOD, VT_I4, (void*)&result, NULL);
	return result;
}

void CIjaCtrl::SetHelpFilePath(LPCTSTR lpszPath)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x16, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszPath);
}

void CIjaCtrl::SetSessionStart(long nStart)
{
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x17, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nStart);
}

void CIjaCtrl::SetSessionDescription(LPCTSTR lpszDescription)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x18, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszDescription);
}

void CIjaCtrl::AboutBox()
{
	InvokeHelper(0xfffffdd8, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}
