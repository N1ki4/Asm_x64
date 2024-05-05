#include "Panel.h"

APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO* screen_buffer, unsigned short screen_width)
	: X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width)
{
}

void APanel::Draw() 
{
    CHAR_INFO symbol{};
    symbol.Char.UnicodeChar = L'-';
    symbol.Attributes = 0x1b;

    SPos pos(2, 1, Screen_Width, 10);

    //Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
    Draw_Line_Vertical(Screen_Buffer, pos, symbol);

    //Show_Colors(Screen_Buffer, pos, symbol);
}