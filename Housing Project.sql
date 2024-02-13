-- Cleaning Data in SQL Queries

Select *
From PortfolioProject..NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(date, SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(date, SaleDate)

alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date, SaleDate)


--Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


-- Breaking out address into individual column (address, city, state)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From PortfolioProject..NashvilleHousing

Select PropertyAddress,
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleHousing
Add PropertyCity Nvarchar(255);

Update NashvilleHousing
Set PropertyCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select*
From PortfolioProject..NashvilleHousing


Select
PARSENAME (replace(OwnerAddress, ',', '.'),3),
PARSENAME (replace(OwnerAddress, ',', '.'),2),
PARSENAME (replace(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousing


alter table NashvilleHousing
Add OnwerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OnwerSplitAddress = PARSENAME (replace(OwnerAddress, ',', '.'),3)

alter table NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
Set Ownercity = PARSENAME (replace(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
Set OwnerState = PARSENAME (replace(OwnerAddress, ',', '.'),1)


--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldasVacant), Count(SoldasVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldasVacant
, Case When SoldasVacant = 'Y' Then 'Yes'
	   When SoldasVacant = 'N' Then 'No'
	   Else SoldasVacant
	   END
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldasVacant = 'Y' Then 'Yes'
	   When SoldasVacant = 'N' Then 'No'
	   Else SoldasVacant
	   END


--Remove Duplicates, not counting uniqueID

with RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject..NashvilleHousing
--order by parcelid
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete unused Columns

sELECT *
From PortfolioProject..NashvilleHousing


alter table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
Drop Column SaleDate