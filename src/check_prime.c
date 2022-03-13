#include <stdio.h>

int main()
{
    int n, i;
    printf("please input an integer:");
    scanf("%d", &n);

    if (n <= 1)
    {
        printf("%d is not a prime\n", n);
    }
    else
    {
        for (i = 2; i <= n / 2; i++)
        {
            if (n % i == 0)
                break;
        }
        if (i >= n / 2)
            printf("%d is a prime.\n", n);
        else
            printf("%d is not a prime.\n", n);
    }

    return 0;
}